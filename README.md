# Verilog Common Errors

This repository is dedicated to documenting common errors we encounter when using Verilog. So the next time you see one of them, you would have an idea how to solve and the reason of it happening.

## How to Contribute

We encourage you to enrich this repository with more error examples and their explanations. Here's how you can contribute:

1. **Submit New Errors**: If you encounter a Verilog error that's not yet documented here, feel free to submit it along with its explanation. Please ensure the explanation is clear and concise.

2. **Expand Existing Entries**: If you believe an existing error entry could benefit from more detailed explanation or additional context, you can enhance it with more information.

3. **Correct Errors**: If you find any inaccuracies in the existing entries, such as incorrect explanations or outdated information, please submit corrections.

To contribute, simply fork this repository, make your changes, and submit a pull request. We will review your pull request and merge them into the main repository as appropriate.

## Common Errors

### 1. Connecting a reg port to reg variable

> Error (10663): Verilog HDL Port Connection error at full_adder.v(14): output or inout port "sum" must be connected to a structural net expression

In Verilog, you cannot directly connect a reg data type to another reg using module connections or continuous assignments. This restriction exists because connecting reg variables directly can lead to race conditions and undefined behavior in simulation.

**Example with this half_adder and full_adder module:** [^1]

```verilog
module half_adder(input wire a, b, output reg sum, output reg carry);
    always @(a or b)
    begin
        sum = a ^ b;
        carry = a & b;
    end
endmodule

module full_adder(input wire a, b, c, output reg sum, output reg carry);
    wire s1, c1, c2;

    half_adder gate1(a, b, s1, c1);
    half_adder gate2(s1, c, sum, c2);

    always @*
        carry = c1 | c2;
endmodule
```

In the example provided, the sum and carry outputs of both half_adder and full_adder modules are declared as reg types. These reg types are being directly connected to each other through module instances, which causes the error to show up. To resolve this error, connect port of instance `gate2` to the wire `s2` instead of `sum`. This would be the code to resolve the issue:

```verilog
module full_adder(input wire a, b, c, output reg sum, output reg carry);
    wire s1, c1, s2, c2;

    half_adder gate1(a, b, s1, c1);
    half_adder gate2(s1, c, s2, c2); // use s2 here

    always @*
        carry = c1 | c2;

    always @*
        sum = s2;
endmodule
```

[^1]: Original issue & answer on Stackoverflow (https://stackoverflow.com/a/69479858/12349259).




### 2. Assigning a value to a reg in 2 diffrent always blocks

> Error (10028): Can't resolve multiple constant drivers for net "count[3]" at counter.v(15)

In Verilog, you cannot assign a value to a reg in the same module in 2 diffrent always blocks even if u assume that they have diffrent conditions
it won't work

**Example** [^1]

```verilog
module counter(
    input wire clk,
    input wire rst,       
    input wire dir,      
    output reg [3:0] count 
);

    always @(posedge rst)
    begin

        count  <= 0;
    end
	 

    always @(posedge clk)
    begin

        count  <= count + 1;
    end
	 
	 
endmodule
```

To sovle this u need to keep the assigning in one always block using conditions instead

```verilog
module counter(
    input wire clk,
    input wire rst,       
    input wire dir,      
    output reg [3:0] count 
);


    always @(posedge clk or posedge rst)
    begin
			
			if (rst) count  <= 0;
			else count  <= count + 1;
    end
	 
	 
endmodule
```

[^1]: Original issue (  https://electronics.stackexchange.com/questions/29601/why-cant-regs-be-assigned-to-multiple-always-blocks-in-synthesizable-verilog).

