#!perl
package DuFaults;

use strict;
use warnings;

use base 'Exporter';

our @EXPORT = qw(get_du_faults get_errors_from_du);

#    // The DU uses the same set of codes for POST, IBIT and CBIT.
#    static struct
#    {
#        otp_du_fault_id_type faultId;
#        UINT32 faultIdNum;
#        UINT32 whichWord;
#        UINT32 whichBit;
#        CHAR const *msg;
#        UINT32 numReportsRequired;  // 0 means it will be passed through without delay
#        UINT32 reportIndex;
#        INT64 periodOfSample;
#        INT64 lastReportTimes[NUM_OF_SAMPLES_TO_EVAL];
#    } duErr2TxtArray[] =
#
# s/\(\s*\S\+\)\s*,\s 0x..U, \(\S\+\)U, \(0x\S\+\)U, \(".*"\)\s\+, 0U.*$/\1 => { word => \2, bit => \3, msg => \4 },/
#
my %du_faults = 
(
    du_ic2_fault                   => { word => 0 , bit => 0x00000002 , msg => "DU IC2 Fault L0x%X"                           }  , 
    du_power_fault                 => { word => 0 , bit => 0x00000004 , msg => "DU Power Fault L0x%X"                         }  , 
    du_fan_fault                   => { word => 0 , bit => 0x00000008 , msg => "DU Fan Fault L0x%X"                           }  , 
    du_backlight_fault             => { word => 0 , bit => 0x00000010 , msg => "DU Backlight Fault L0x%X"                     }  , 
    du_amlcd_fault                 => { word => 0 , bit => 0x00000020 , msg => "DU AMLCD Fault L0x%X"                         }  , 
    du_ts_fault                    => { word => 0 , bit => 0x00000040 , msg => "DU Touch Screen Fault L0x%X"                  }  , 
    du_heater_fault                => { word => 0 , bit => 0x00000080 , msg => "DU Heater Fault L0x%X"                        }  , 
    du_fram_fault                  => { word => 0 , bit => 0x00000100 , msg => "DU FRAM Fault L0x%X"                          }  , 
    du_adc_fault                   => { word => 0 , bit => 0x00000200 , msg => "DU ADC Fault L0x%X"                           }  , 
    du_io_expander_fault           => { word => 0 , bit => 0x00000400 , msg => "DU IO Expander Fault L0x%X"                   }  , 
    du_multiplexer_fault           => { word => 0 , bit => 0x00000800 , msg => "DU Multiplexer Fault L0x%X"                   }  , 
    du_eti_fault                   => { word => 0 , bit => 0x00001000 , msg => "DU ETI Fault L0x%X"                           }  , 
    du_eeprom_fault                => { word => 0 , bit => 0x00002000 , msg => "DU EEPROM Fault L0x%X"                        }  , 
    du_osd_fault                   => { word => 0 , bit => 0x00004000 , msg => "DU OSD Fault L0x%X"                           }  , 
    du_ts_failed_beams_fault       => { word => 0 , bit => 0x00008000 , msg => "DU Touch Screen Failed Beams Fault L0x%X"     }  , 
    du_lut_version_fault           => { word => 0 , bit => 0x00010000 , msg => "DU LUT Version Fault L0x%X"                   }  , 
    du_calibration_fault           => { word => 0 , bit => 0x00020000 , msg => "DU Calibration Fault L0x%X"                   }  , 
    du_cfg_version_fault           => { word => 0 , bit => 0x00040000 , msg => "DU Config Version Fault L0x%X"                }  , 
    du_not_used_fault              => { word => 0 , bit => 0x00080000 , msg => "DU Not Used Fault L0x%X"                      }  , 
    du_dc_fault                    => { word => 0 , bit => 0x00100000 , msg => "DU DC Fault L0x%X"                            }  , 
    du_fan_timeout_fault           => { word => 0 , bit => 0x00200000 , msg => "DU Fan Timeout Fault L0x%X"                   }  , 
    du_ts_timeout_fault            => { word => 0 , bit => 0x00400000 , msg => "DU Touch Screen Timeout Fault L0x%X"          }  , 
    du_overtemp_fault              => { word => 0 , bit => 0x00800000 , msg => "DU Overtemp Fault L0x%X"                      }  , 
    du_backlight_timeout_fault     => { word => 0 , bit => 0x01000000 , msg => "DU Backlight Timeout Fault L0x%X"             }  , 
    du_amlcd_dac_fault             => { word => 0 , bit => 0x02000000 , msg => "DU AMLCD DAC Fault L0x%X"                     }  , 
    du_not_used_2_fault            => { word => 0 , bit => 0x04000000 , msg => "DU Not Used 2 Fault L0x%X"                    }  , 
    du_hw_sw_version_fault         => { word => 0 , bit => 0x08000000 , msg => "DU HW/SW Version Fault L0x%X"                 }  , 
    du_flash_crc_fault             => { word => 0 , bit => 0x10000000 , msg => "DU Flash CRC Fault L0x%X"                     }  , 
    du_ram_fault                   => { word => 0 , bit => 0x20000000 , msg => "DU RAM Fault L0x%X"                           }  , 
    du_flash_crc_timeout_fault     => { word => 0 , bit => 0x40000000 , msg => "DU Flash CRC Timeout Fault L0x%X"             }  , 
    du_ram_timeout                 => { word => 0 , bit => 0x80000000 , msg => "DU RAM Timeout L0x%X"                         }  , 
    du_backlight_temp_sensor_fault => { word => 1 , bit => 0x00000001 , msg => "DU Backlight Temp Sensor Fault H0x%X"         }  , 
    du_ts_stylus_fault             => { word => 1 , bit => 0x00000002 , msg => "DU Touch Screen Stylus Fault H0x%X"           }  , 
    du_ts_read_fault               => { word => 1 , bit => 0x00000004 , msg => "DU Touch Screen Read Fault H0x%X"             }  , 
    du_gamma_dac_fault             => { word => 1 , bit => 0x00000008 , msg => "DU Gamma DAC Fault H0x%X"                     }  , 
    du_ts_bit_fault                => { word => 1 , bit => 0x00000010 , msg => "DU Touch Screen BIT Fault H0x%X"              }  , 
    du_backlight_dc_fault          => { word => 1 , bit => 0x00000020 , msg => "DU Backlight DC Fault H0x%X"                  }  , 
    du_not_used_3_fault            => { word => 1 , bit => 0x00000040 , msg => "DU Not Used 3 Fault H0x%X"                    }  , 
    du_not_used_4_fault            => { word => 1 , bit => 0x00000080 , msg => "DU Not Used 4 Fault H0x%X"                    }  , 
    du_ts_blocked_beams_fault      => { word => 1 , bit => 0x00000100 , msg => "DU Touch Screen Blocked Beams Fault H0x%X"    }  , 
    du_amdlc_temp_sensor_fault     => { word => 1 , bit => 0x00000200 , msg => "DU AMDLC Temperature Sensor Fault H0x%X"      }  , 
    du_not_used_5_fault            => { word => 1 , bit => 0x00000400 , msg => "DU Not Used 5 Fault H0x%X"                    }  , 
    du_internal_buffer_fault       => { word => 1 , bit => 0x00000800 , msg => "DU Internal Buffer Fault H0x%X"               }  , 
    du_day_night_switch_fault      => { word => 1 , bit => 0x00001000 , msg => "DU Day/Night Switch Fault H0x%X"              }  , 
    du_serial_port_fault           => { word => 1 , bit => 0x00002000 , msg => "DU Serial Port Fault H0x%X"                   }  , 
    du_protocol_check_fault        => { word => 1 , bit => 0x00004000 , msg => "DU Protocol Check Fault H0x%X"                }  , 
    du_not_used_6_fault            => { word => 1 , bit => 0x00008000 , msg => "DU Not Used 6 Fault H0x%X"                    }  , 
    du_emi_temp_sensor_fault       => { word => 1 , bit => 0x00010000 , msg => "DU EMI Temperature Sensor Fault H0x%X"        }  , 
    du_gamma_table_fault           => { word => 1 , bit => 0x00020000 , msg => "DU Gamma Table Fault H0x%X"                   }  , 
    du_fpga_fault                  => { word => 1 , bit => 0x00040000 , msg => "DU FPGA Fault H0x%X"                          }  , 
    du_fpga_read_fault             => { word => 1 , bit => 0x00080000 , msg => "DU FPGA Read Fault H0x%X"                     }  , 
    du_amlcd_voltage_fault         => { word => 1 , bit => 0x00100000 , msg => "DU AMLCD Voltage Fault H0x%X"                 }  , 
    du_invalid_msg_fault           => { word => 1 , bit => 0x00200000 , msg => "DU Invalid Message Fault H0x%X"               }  , 
    du_wrong_size_fault            => { word => 1 , bit => 0x00400000 , msg => "DU Wrong Size Fault H0x%X"                    }  , 
    du_wrong_cfg_fault             => { word => 1 , bit => 0x00800000 , msg => "DU Wrong Configuration Fault H0x%X"           }  , 
    du_up_down_switch_fault        => { word => 1 , bit => 0x01000000 , msg => "DU Up/Down Switch Fault H0x%X"                }  , 
    du_ts_reset_fault              => { word => 1 , bit => 0x02000000 , msg => "DU Touch Screen Reset Fault H0x%X"            }  , 
    du_ts_protocol_version_fault   => { word => 1 , bit => 0x04000000 , msg => "DU Touch Screen Protocol Version Fault H0x%X" }  , 
    du_io_expander_read_fault      => { word => 1 , bit => 0x08000000 , msg => "DU IO Expander Read Fault H0x%X"              }  , 
    du_eu_comms_timeout_fault      => { word => 1 , bit => 0x10000000 , msg => "DU EU Communication Timeout Fault H0x%X"      }  , 
    du_serial_port_init_fault      => { word => 1 , bit => 0x20000000 , msg => "DU Serial Port Initialization Fault H0x%X"    }  , 
    du_post_fault                  => { word => 1 , bit => 0x40000000 , msg => "DU POST Fault H0x%X"                          }  , 
    du_ibit_fault                  => { word => 1 , bit => 0x80000000 , msg => "DU IBIT Fault H0x%X"                          }
);


sub get_du_faults
{
    return %du_faults;
}

sub get_errors_from_du
{
    my $searchWord = $_[0];
    my $searchBits = $_[1];
    my @results = ();

    for (my $i = 0; $i < 32; $i++)
    {
        my $bit = 2 ** $i;
        if (($bit & $searchBits) != 0)
        {
            while (my ($key, $value) = each(%du_faults))
            {
                if (($value->{word} == $searchWord) && ($value->{bit} == $bit))
                {
                    push(@results, $value->{msg});
                }
            }
        }
    }
    return @results;
}

1;

