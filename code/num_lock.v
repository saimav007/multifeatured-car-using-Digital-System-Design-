module num_lock(in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,alarm,correct_signal);
input in0,in1,in2,in3,in4,in5,in6,in7,in8,in9;
output reg alarm,correct_signal;
always@(*)begin
if(in1==1'b1 && in2==1'b1 && in3==1'b1 && in4==1'b1 )begin
alarm<=1'b0;
correct_signal<=1'b1;
end
else begin 
alarm<=1'b1;
correct_signal<=1'b0;
end
end
endmodule
module test();
reg in0,in1,in2,in3,in4,in5,in6,in7,in8,in9;
wire alarm,correct_signal;
num_lock nl1(in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,alarm,correct_signal);
initial begin
#5;
in0=1'b1;in1=1'b1;in2=1'b1;in3=1'b1;
#5;
in1=1'b1;in2=1'b1;in3=1'b1;in4=1'b1;
#5;
in0=1'b1;in1=1'b1;in6=1'b1;in9=1'b1;
end
initial begin
    $monitor("time=%0t, in1=%b,in2=%b,in3=%b,in4=%b,alarm=%b,correct_signal=%b", $time,in1,in2,in3,in4,alarm,correct_signal);
    $dumpfile("adder_4bit.vcd");
    $dumpvars();
  end
endmodule
