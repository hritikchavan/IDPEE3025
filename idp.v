module calculator (A,B,O,CLK,C,sign);
   input [3:0] A;   // The 4-bit augend/minuend.
   input [3:0] B;   // The 4-bit addend/subtrahend.
   input [1:0] O;  // The operation: 0 => Add, 1=>Subtract.
   input CLK;
   output [7:0] C;
  output sign;
  reg signt,sign;
  reg [3:0] a,b;
  reg [7:0] answer,C=0;
  wire [7:0] add,mul,div;
  always @(A or B)
  begin
    if (O == 2'b01)
    begin
      if (A<B)
      begin
        a = B;
        b = A;
        signt = 1;
      end
      else
      begin
        a = A;
        b = B;
        signt = 0;
      end
    end
    else if (O == 2'b11)
    begin
      if (B==0)
      begin
        signt = 1;
        a = B;
        b = A;
      end
      else
      begin
        signt = 0;
        a = A;
        b = B;
      end
    end
    else
    begin
      signt = 0;
      a = A;
      b = B;
    end
    sign = signt;
  end
  adder add_sub(a,b,add,O[0]);
  M4bit multiply(a,b,mul);
  division divide(a,b,div);

   always @(posedge(CLK))
//deciding the operation based on the op code given  
   begin
   	if (O[1] == 0)
   		answer = add;  // add or subtract
   	else
   	begin
   		if (O[0] == 0)
   			answer = mul; //multiply
   		else
   			answer = div; //divide
   	end
     C = answer;
   end
endmodule

//adder and subtractor
module adder (A,B,R,Op);
   input [3:0] A;   
   input [3:0] B;   
   input Op; 
  output [7:0] R;
   wire  C0; 
   wire  C1; 
   wire  C2; 
   wire  C3; 
   wire  B0; 
   wire  B1; 
   wire  B2; 
   wire  B3; 
   xor(B0, B[0], Op);
   xor(B1, B[1], Op);
   xor(B2, B[2], Op);
   xor(B3, B[3], Op);

  full_adder fa0(R[0], C0, A[0], B0, Op);    
  full_adder fa1(R[1], C1, A[1], B1, C0);
  full_adder fa2(R[2], C2, A[2], B2, C1);
  full_adder fa3(R[3], C3, A[3], B3, C2);    
  xor (R[4],C3,Op);
  and (R[5],0,0);
  and (R[6],0,0);
  and (R[7],0,0);
endmodule

//full adder
module full_adder(S, Cout, A, B, Cin);
   output S;
   output Cout;
   input  A;
   input  B;
   input  Cin;
   
   wire   w1;
   wire   w2;
   wire   w3;
   wire   w4;
   
   xor(w1, A, B);
   xor(S, Cin, w1);
   and(w2, A, B);   
   and(w3, A, Cin);
   and(w4, B, Cin);   
   or(Cout, w2, w3, w4);
endmodule 

// multiplier
module M4bit(

input [3:0] Q,
input [3:0] M,
output [7:0] P
);

wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11;
wire d1,d2,d3,d4,d5,d6,d7;
wire e1,e2,e3;
wire f1,f2,f3,f4,f5,f6,f7;
wire g1,g2,g3,g4;
and(c1,M[3],Q[1]),
(c2,M[2],Q[2]),
(c3,M[1],Q[3]),
(c4,M[3],Q[0]),
(c5,M[2],Q[1]),
(c6,M[1],Q[2]),
(c7,M[2],Q[0]),
(c8,M[1],Q[1]),
(c9,M[0],Q[2]),
(c10,M[1],Q[0]),
(c11,M[0],Q[1]),
(P[0],M[0],Q[0]);

full_adder fa1(d2,d1,c1,c2,c3);
full_adder fa2(d4,d3,c4,c5,c6);
full_adder fa3(d6,d5,c7,c8,c9);
full_adder fa4(P[1],d7,c10,c11,0);

and(e1,M[2],Q[3]),
(e2,M[3],Q[2]),
(e3,M[0],Q[3]);
full_adder fa5(f2,f1,e1,e2,d1);
full_adder fa6(f4,f3,d2,d3,f5);
full_adder fa7(f6,f5,d4,e3,d5);
full_adder fa8(P[2],f7,d6,d7,0);

and(g1,M[3],Q[3]);
full_adder fa9(P[6],P[7],g1,f1,g2);
full_adder fa10(P[5],g2,f2,f3,g3);
full_adder fa11(P[4],g3,f4,0,g4);
full_adder fa12(P[3],g4,f6,f7,0);

endmodule


// division
module division(A,B,Res);

    input [3:0] A;
    input [3:0] B;
    output [7:0] Res;
    reg [7:0] Res = 0;
    reg [3:0] a1,b1;
    reg [4:0] p1;   
    integer i;

    always@ (A or B)
    begin
      if (A<B)
        begin
          Res = 0;
        end
      else if (A == B)
        begin
          Res = 1;
        end
      else
        begin
	if (B > 4'b1001)
		Res = 1;
	else
	begin
  		//initialize the variables.
        a1 = A;
        b1 = B;
        p1= 0;
        for(i=0;i < 4;i=i+1)    
          begin //start the for loop
            p1 = {p1[2:0],a1[3]};
            a1[3:1] = a1[2:0];
            p1 = p1-b1;
            if(p1[3] == 1)    begin
                a1[0] = 0;
                p1 = p1 + b1;   end
            else
                a1[0] = 1;
        end
	Res = a1;
	end
	end   
    end

  endmodule