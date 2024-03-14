//Common Mistakes in Verilog
// 1.Assign a value twice to a variable in different always block
// error message: "Multiple drivers for net"

//example from lab3 'counter' module:

always @(SW[2]) begin

if(SW[2])
     num <= 0;

end

always @(posedge KEY[0]) begin
    if(SW[1]  && ( SW[0] == 0 ) ) 
        num <= num+1;

     else if (SW[0] && ( SW[1] == 0) )
        num <= num-1;

end



//solution:


always @(posedge KEY[0]) begin



if(SW[2])
num <= 0;
      
      
    else begin
    
    
    if(SW[1]  && ( SW[0] == 0 ) ) 
        num <= num+1;

     else if (SW[0] && ( SW[1] == 0) )
        num <= num-1;


        end
end