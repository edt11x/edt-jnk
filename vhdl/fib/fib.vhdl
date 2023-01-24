
-- Youtube, Lesson 88 - Example 59: Fibonacci Sequence

-- Fibonacci series
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use std.textio.all;

-- Define the design without any ports
entity fib is
end fib;

architecture behavior of fib is
begin
    process
        variable l : line;
    begin
        write(l, String'("Hello World!"));
        writeline (output, l);
        wait;
    end process;
end behavior;
