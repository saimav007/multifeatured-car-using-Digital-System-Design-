module num_lock(
    input in0, in1, in2, in3, in4, in5, in6, in7, in8, in9,
    input clk, reset,  // Add clock and reset inputs
    output reg alarm, correct_signal
);
    reg [1:0] count1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count1 <= 2'b00;  // Reset the counter on reset signal
            alarm <= 1'b0;  // Reset the alarm
            correct_signal <= 1'b0;  // Reset the correct_signal
        end
        else begin
            if (in1 == 1'b1 && in2 == 1'b1 && in3 == 1'b1 && in4 == 1'b1) begin
                alarm <= 1'b0;
                correct_signal <= 1'b1;
                count1 <= 2'b00;  // Reset the counter on correct input
            end
            else begin
                correct_signal <= 1'b0;
                count1 <= count1 + 1;  // Increment the counter on incorrect input
                if (count1 == 2'b10) begin  // Activate alarm on third failed attempt
                    alarm <= 1'b1;
                end
            end
        end
    end
endmodule

module test();
    reg in0, in1, in2, in3, in4, in5, in6, in7, in8, in9;
    reg clk, reset;
    wire alarm, correct_signal;

    num_lock nl1(in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, clk, reset, alarm, correct_signal);

    initial begin
        clk = 1'b0;
        reset = 1'b1;  // Start with reset active
        #5;
        reset = 1'b0;  // Release reset
        in1 = 1'b1; in2 = 1'b0; in3 = 1'b1; in4 = 1'b1;  // 1st incorrect attempt
        #10;
        in1 = 1'b1; in2 = 1'b1; in3 = 1'b0; in4 = 1'b1;  // 2nd incorrect attempt
        #10;
        in1 = 1'b1; in2 = 1'b1; in3 = 1'b1; in4 = 1'b0;  // 3rd incorrect attempt, should trigger alarm
        #10;
        in1 = 1'b1; in2 = 1'b1; in3 = 1'b1; in4 = 1'b1;  // Correct attempt, should reset alarm
        #30 $stop();
    end

    always #5 clk = ~clk;  // Generate clock signal

    initial begin
        $monitor("time=%0t, clk=%b, reset=%b, in1=%b, in2=%b, in3=%b, in4=%b, alarm=%b, correct_signal=%b", $time, clk, reset, in1, in2, in3, in4, alarm, correct_signal);
        $dumpfile("num_lock.vcd");
        $dumpvars();
    end
endmodule
