
-- Hello world
use std.textio.all;

-- Define the design without any ports
entity hello_world is
end hello_world;

architecture behavior of hello_world is
begin
    process
        variable l : line;
    begin
        write(l, String'("Hello World!"));
        writeline (output, l);
        wait;
    end process;
end behavior;
