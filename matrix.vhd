library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity matrix is
    port (  clock: in std_logic; 
            reset : in std_logic;   
            set : in std_logic;
            A,B : in std_logic_vector(44 downto 0); --5*9= 45 bits gia ka8e mhtrwo
            C : out std_logic_vector(44 downto 0));
end matrix;

architecture arc of matrix is
    type matrix3x3 is array (0 to 2, 0 to 2) of std_logic_vector(4 downto 0);

    signal matrixA, matrixB, matrixC: matrix3x3;
    type stateType is (start,multiply,output);
    signal state : stateType := start;
    signal i,j : integer := 0;
    begin
    process (clock, reset)
        variable mult : std_logic_vector(9 downto 0) := (others => '0');
        begin
            if (reset = '1') then
                i<=0;
                j<=0;
                matrixA <= (others => (others => "00000"));
                matrixB <= (others => (others => "00000"));
                matrixC <= (others => (others => "00000"));
                state <= start;
            elsif rising_edge(clock) then
                case state is
                    when start =>
                        if(set = '1') then
                            for i in 0 to 2 loop    
                                for j in 0 to 2 loop
                                    matrixA(i,j) <= A((i*3+j+1)*5-1 downto (i*3+j)*5);
                                    matrixB(i,j) <= B((i*3+j+1)*5-1 downto (i*3+j)*5);
                                end loop;
                            end loop;
                        state <= multiply;
                        end if;
                    when multiply => 
                        mult := matrixA(i,j) * matrixB(i,j);  
                        matrixC(i,j) <= mult(4 downto 0);
                        
                    if(j = 2) then
                        j <= 0;
                        if (i= 2) then
                            i <= 0;
                            state <= output;
                        else
                            i <= i + 1;
                        end if;
                    else
                        j <= j+1;
                    end if;   
                    when output =>
                    for i in 0 to 2 loop 
                        for j in 0 to 2 loop 
                            C((i*3+j+1)*5-1 downto (i*3+j)*5) <= matrixC(i,j);
                        end loop;
                    end loop;   
                    state <= start;
        end case;
        end if;
end process;

end arc;
