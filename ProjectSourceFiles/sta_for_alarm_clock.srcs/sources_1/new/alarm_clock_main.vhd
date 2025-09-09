library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_module is
  Port ( 
    aclk : in std_logic;
    A : in unsigned (7 downto 0) := "00000000";
    B : in unsigned (7 downto 0) := "00000000";
    C : in unsigned (7 downto 0) := "00000000";
    D : in unsigned (7 downto 0) := "00000000";
    output : out unsigned (23 downto 0)
  );
end top_module;

architecture Behavioral of top_module is
    signal output_temp1 : unsigned(15 downto 0);
    signal output_temp2 : unsigned(23 downto 0);
begin
    process(aclk, A,B,C,D) 
    begin
        if(rising_edge (aclk)) then
            output_temp1 <= A*B;
            output_temp2 <= output_temp1*C;
            output <= output_temp2 + D;
        end if;
    end process;

end Behavioral;
