module HalfAdder(sum, carry, A, B);
input A,B;
output sum, carry;
xor(sum, A, B);
and(carry, A, B);
endmodule

module fulladd(Sum, Cary, X, Y, Z);
input X, Y, Z;
output Sum, Cary;
wire w1, w2, w3;
HalfAdder HA_0(w1, w2, X, Y);
HalfAdder HA_1(Sum, w3, w1, Z);
or(Cary, w2, w3);
endmodule

module fulla2(s0,s1,carry,a,b,cin);
 input[1:0] a,b;
 input cin; 
 output s0,s1,carry;
 wire carry1;
 fulladd f1(s0,carry1,a[0],b[0],cin);
 fulladd f2(s1,carry,a[1],b[1],carry1);
endmodule

module fulla4(sum,carry,a,b,cin);
 input[3:0]a,b;
input cin;
output[3:0] sum;
output carry;
 wire w1;
 fulla2 n1(sum[0],sum[1],w1,a[1:0],b[1:0],cin);
 fulla2 n2(sum[2],sum[3],carry,a[3:2],b[3:2],w1);
endmodule

module fullsub(sum,carry,a,b,cin);
 input[3:0]a,b;
input cin;
output[3:0] sum;
output carry;
 wire w1;
 fulla2 n1(sum[0],sum[1],w1,a[1:0],b[1:0],cin);
 fulla2 n2(sum[2],sum[3],carry,a[3:2],b[3:2],w1);
 assign carry=0;
endmodule

module inc(cout,c,a);
input[3:0] a;	output[3:0]cout; output c;
wire [3:0] b;
assign b[0]=1;
assign b[1]=0;
assign b[2]=0;
assign b[3]=0;
wire x;
assign x=0;
fulla4 lm(cout,c,a,b,x);
endmodule

module dec(cout,a);
input[3:0] a;	output[3:0]cout; wire [3:0] b;
assign b[0]=1;
assign b[1]=1;
assign b[2]=1;
assign b[3]=1;
wire x;
assign x=1;
fulla4 gm(cout,c,a,b,x);
endmodule

module ls(cout,a);
input [3:0] a;
output[4:0] cout;
assign cout[4]=a[3];
assign cout[3]=a[2];
assign cout[2]=a[1];
assign cout[1]=a[0];
assign cout[0]=0;

endmodule

module and4 (c,a,b);
input[3:0] a,b;
output [3:0] c;

and(c[3],a[3],b[3]);
and(c[2],a[2],b[2]);
and(c[1],a[1],b[1]);
and(c[0],a[0],b[0]);
endmodule

module or4(c,a,b);
input[3:0] a,b;
output [3:0] c;
or(c[3],a[3],b[3]);
or(c[2],a[2],b[2]);
or(c[1],a[1],b[1]);
or(c[0],a[0],b[0]);
endmodule

module xor4(c,a,b);
input[3:0] a,b;
output [3:0] c;

xor(c[3],a[3],b[3]);
xor(c[2],a[2],b[2]);
xor(c[1],a[1],b[1]);
xor(c[0],a[0],b[0]);
endmodule

module not4(c,a);
input[3:0] a;
output [3:0] c;

not(c[3],a[3]);
not(c[2],a[2]);
not(c[1],a[1]);
not(c[0],a[0]);
endmodule 

module multiplex2(x,a,b,s);
 output x;
wire a1,b1,sbar;
 input a, b;
 input s;
 not(sbar,s);
 and(a1,a,sbar);
 and(b1,b,s);
 or(x,a1,b1);
endmodule

module mux4(out,a,b,c,d,s);
 input a,b,c,d;
 input [1:0] s;
 output out;
 wire mux[2:0];
 multiplex2 m1 (x,a,c,s[0]), m2 (y,b,d,s[0]), m3 (out,x,y,s[1]);
endmodule

module quadmux(out,a,b,c,d,s);

input[4:0] a,b,c,d;
input[1:0]s;
output[4:0]out;
 mux4 m1(out[0],a[0],b[0],c[0],d[0],s[1:0]), m2(out[1],a[1],b[1],c[1],d[1],s[1:0]), m3(out[2],a[2],b[2],c[2],d[2],s[1:0])
 ,m4 (out[3],a[3],b[3],c[3],d[3],s[1:0]) ,m5(out[4],a[4],b[4],c[4],d[4],s[1:0]);
endmodule

module quadmux2(out,a,b,s);

input[4:0] a,b;
input s;
output[4:0]out;
 multiplex2 m1(out[0],a[0],b[0],s), m2(out[1],a[1],b[1],s), m3(out[2],a[2],b[2],s), m4(out[3],a[3],b[3],s), m5(out[4],a[4],b[4],s);
endmodule

module ALU(c,a,b,s,carryinp);
output[4:0] c;
wire[4:0] sum,dif,incr,decr,lshift,multi,adsub;
input[3:0] a,b;
input[4:0] s;
input carryinp;
fulla4 m1(sum[3:0],sum[4],a[3:0],b[3:0],carryinp);
fullsub mf(dif[3:0],dif[4],a[3:0],b[3:0],carryinp);
quadmux2 qm2(adsub[4:0],sum[4:0],dif[4:0],carryinp);
assign incr[4]=0;
assign decr[4]=0;
inc m2(incr[3:0],incr[4],a[3:0]);
dec m3(decr[3:0],a[3:0]);
ls m4(lshift[4:0],a[3:0]);
wire[4:0] an,orr,nott,xxor;
assign an[4]=0,orr[4]=0,nott[4]=1,xxor[4]=0;
and4 m5(an[3:0],a[3:0],b[3:0]);
xor4 m6(xxor[3:0],a[3:0],b[3:0]);
or4 m7(orr[3:0],a[3:0],b[3:0]);
not4 m8(nott[3:0],a[3:0]);

wire[4:0] wireau, wirelu,OUT;
assign wirelu[4]=0;
quadmux m9(wireau[4:0],adsub[4:0],incr[4:0],decr[4:0],lshift[4:0],s[1:0]), m10(wirelu[4:0],an[4:0],orr[4:0],xxor[4:0],nott[4:0],s[3:2]);
quadmux2 m11(c[4:0],wireau[4:0],wirelu[4:0],s[4]);

endmodule
