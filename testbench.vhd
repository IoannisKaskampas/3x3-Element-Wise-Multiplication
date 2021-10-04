library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity tb_matrix is
end entity;

architecture behav of tb_matrix is

component matrix is
    port (  clock: in std_logic; 
            reset : in std_logic;   
            start : in std_logic;
            A,B : in std_logic_vector(44 downto 0); --5*9= 45 bits gia ka8e mhtrwo
            C : out std_logic_vector(44 downto 0);
            done : out std_logic);
end component;

signal A,B,C : std_logic_vector(44 downto 0);
signal clock,reset, start, done : std_logic := '0';
type matrix3x3 is array(0 to 2,0 to 2) of std_logic_vector(4 downto 0);
signal matrixC : matrix3x3 := (others => (others => "00000")); 

begin

matrix_multiplier : matrix port map (clock, reset, start, A,B, C,done);

clk_generator : process
begin
    wait for 10 ns;
    clock <= not clock;
end process;

apply_inputs : process
begin
    reset <= '1';
    wait for 100 ns;
    reset <= '0';
    wait for 20 ns;
    A <= "00110" & "00000" & "00111" & "00101" & "00011" & "00011" & "00001" & "00001" & "00001";
    B <= "00010" & "01111" & "00010" & "00011" & "00100" & "00011" & "11111" & "11001" & "01111";
    start <= '1';
    wait for 20 ns;
    start <= '0';
    wait until done = '1';
    wait for 5 ns;
    for i in 0 to 2 loop
        for j in 0 to 2 loop
            matrixC(i, j) <= C((i * 3 + j + 1) * 5 - 1 downto (i * 3 + j) * 5);
        end loop;
    end loop;
    wait;
end process;

end behav;


