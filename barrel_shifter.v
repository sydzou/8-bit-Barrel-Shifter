`timescale 1ns / 1ps


module barrel_shifter(a,s,opcode,y,overflow);
    input [7:0] a;
    input [2:0] s,opcode;
    output reg [7:0] y;
    output reg overflow;
    wire [7:0] t1,t2,t3,t4,t5,t6;
    wire flag;


    ar_left al(a,s,t1,flag);
    log_left ll(a,s,t2);
    cr_left cl(a,s,t3);
    ar_right ar(a,s,t4);
    log_right lr(a,s,t5);
    cr_right cr(a,s,t6);

    parameter [2:0]
    ARLEFT = 3'b000,
    LOGLEFT = 3'b001,
    CRLEFT = 3'b010,
    ARRIGHT = 3'b100,
    LOGRIGHT = 3'b101,
    CRRIGHT = 3'b110;

    always@(*)
    begin
        case(opcode)
            ARLEFT: begin
                y = t1;
                overflow = flag;
            end

            LOGLEFT: begin
                y = t2;
                overflow = 1'b0;
            end

            CRLEFT: begin
                y = t3;
                overflow = 1'b0;
            end

            ARRIGHT: begin
                y = t4;
                overflow = 1'b0;
            end

            LOGRIGHT: begin
                y = t5;
                overflow = 1'b0;
            end

            CRRIGHT: begin
                y = t6;
                overflow = 1'b0;
            end

            default: begin

                y = 8'd0;
                overflow = 1'b0;

            end
        endcase
    end

endmodule

module log_right(a,s,y);

    input [7:0] a;
    input [2:0] s;
    output [7:0] y;

    wire [7:0] p1,p2,a2,b1,b2;
    // 4 bit shift
    assign a2 = {{4{1'b0}},a[7],a[6],a[5],a[4]};

    genvar i;

    generate
        for(i=0;i<8;i=i+1) begin: logright3

            mux21 lr3 (a[i],a2[i],s[2],p1[i]);

        end
    endgenerate



    //2 bit shift
    assign p2 = {{2{1'b0}},p1[7],p1[6],p1[5],p1[4],p1[3],p1[2]};

    genvar j;

    generate
        for(j=0;j<8;j=j+1) begin: logright2

            mux21 lr2 (p1[j],p2[j],s[1],b1[j]);

        end
    endgenerate



    //1 bit shift

    assign b2 = {1'b0,p1[7],b1[6],b1[5],b1[4],b1[3],b1[2],b1[1]};

    genvar k;

    generate
        for(k=0;k<8;k=k+1) begin: logright1

            mux21 lr1 (b1[k],b2[k],s[0],y[k]);

        end
    endgenerate

endmodule

module log_left(a,s,y);

    input [7:0] a;
    input [2:0] s;
    output [7:0] y;

    wire [7:0] p1,p2,a2,b1,b2;
    //4 bit shift
    assign a2 = {a[4],a[3],a[2],a[0],{4{1'b0}}};

    genvar i;

    generate
        for(i=0;i<8;i=i+1) begin: logleft3

            mux21 ll3 (a[i],a2[i],s[2],p1[i]);

        end
    endgenerate



    //2 bit shift
    assign p2 = {p1[5],p1[4],p1[3],p1[2],p1[1],p1[0],{2{1'b0}}};


    genvar j;

    generate
        for(j=0;j<8;j=j+1) begin: logleft2

            mux21 ll2 (p1[j],p2[j],s[1],b1[j]);

        end
    endgenerate



    //1 bit shift

    assign b2 = {b1[6],b1[5],b1[4],b1[3],b1[2],b1[1],b1[0],1'b0};

    genvar k;

    generate
        for(k=0;k<8;k=k+1) begin: logleft1

            mux21 ll1 (b1[k],b2[k],s[0],y[k]);

        end
    endgenerate

endmodule

module ar_left(a,s,y,f);

    input [7:0] a;
    input [2:0] s;
    output [7:0] y;
    output f;

    wire [7:0] p1,p2,a2,b1,b2;
    //4 bit shifft
    assign a2 = {a[3],a[2],a[1],a[0],{4{1'b0}}};

    genvar i;

    generate
        for(i=0;i<8;i=i+1) begin: arleft3

            mux21 al3 (a[i],a2[i],s[2],p1[i]);

        end
    endgenerate



    //2 bit shift
    assign p2 = {p1[5],p1[4],p1[3],p1[2],p1[1],p1[0],{2{1'b0}}};


    genvar j;

    generate
        for(j=0;j<8;j=j+1) begin: arleft2

            mux21 al2 (p1[j],p2[j],s[1],b1[j]);

        end
    endgenerate



    //1 bit shift

    assign b2 = {b1[6],b1[5],b1[4],b1[3],b1[2],b1[1],b1[0],1'b0};

    genvar k;

    generate
        for(k=0;k<8;k=k+1) begin: arleft1

            mux21 al1 (b1[k],b2[k],s[0],y[k]);

        end
    endgenerate

    assign f=a[7]^y[7];
endmodule

module ar_right(a,s,y);

    input [7:0] a;
    input [2:0] s;
    output [7:0] y;

    wire [7:0] p1,p2,a2,b1,b2;
    //4 bit shift
    assign a2 = {{4{a[7]}},a[7],a[6],a[5],a[4]};

    genvar i;

    generate
        for(i=0;i<8;i=i+1) begin: arright3

            mux21 ar3 (a[i],a2[i],s[2],p1[i]);

        end
    endgenerate



    //2 bit shift
    assign p2 = {{2{p1[7]}},p1[7],p1[6],p1[5],p1[4],p1[3],p1[2]};


    genvar j;

    generate
        for(j=0;j<8;j=j+1) begin: arright2

            mux21 ar2 (p1[j],p2[j],s[1],b1[j]);

        end
    endgenerate



    //1 bit shift

    assign b2 = {b1[7],b1[7],b1[6],b1[5],b1[4],b1[3],b1[2],b1[1]};

    genvar k;

    generate
        for(k=0;k<8;k=k+1) begin: arright1

            mux21 ar1 (b1[k],b2[k],s[0],y[k]);

        end
    endgenerate
endmodule

module cr_right(a,s,y);

    input [7:0] a;
    input [2:0] s;
    output [7:0] y;

    wire [7:0] p1,p2,a2,b1,b2;

    //4 bit shift
    assign a2 = {a[3],a[2],a[1],a[0],a[7],a[6],a[5],a[4]};

    genvar i;

    generate
        for(i=0;i<8;i=i+1) begin: crright3

            mux21 cr3 (a[i],a2[i],s[2],p1[i]);

        end
    endgenerate



    //2 bit shift
    assign p2 = {p1[1],p1[0],p1[7],p1[6],p1[5],p1[4],p1[3],p1[2]};


    genvar j;

    generate
        for(j=0;j<8;j=j+1) begin: crright2

            mux21 cr2 (p1[j],p2[j],s[1],b1[j]);

        end
    endgenerate



    //1 bit shift

    assign b2 = {b1[0],b1[7],b1[6],b1[5],b1[4],b1[3],b1[2],b1[1]};

    genvar k;

    generate
        for(k=0;k<8;k=k+1) begin: crright1

            mux21 cr1 (b1[k],b2[k],s[0],y[k]);

        end
    endgenerate

endmodule

module cr_left(a,s,y);

    input [7:0] a;
    input [2:0] s;
    output [7:0] y;

    wire [7:0] p1,p2,a2,b1,b2;

    //4 bit shift
    assign a2 = {a[4],a[3],a[2],a[0],a[7],a[6],a[5]};

    genvar i;

    generate
        for(i=0;i<8;i=i+1) begin: crleft3

            mux21 cl3 (a[i],a2[i],s[2],p1[i]);

        end
    endgenerate



    //2 bit shift
    assign p2 = {p1[5],p1[4],p1[3],p1[2],p1[1],p1[0],p1[7],p1[6]};


    genvar j;

    generate
        for(j=0;j<8;j=j+1) begin: crleft2

            mux21 cl2 (p1[j],p2[j],s[1],b1[j]);

        end
    endgenerate



    //1 bit shift

    assign b2 = {b1[6],b1[5],b1[4],b1[3],b1[2],b1[1],b1[0],b1[7]};

    genvar k;

    generate
        for(k=0;k<8;k=k+1) begin: crleft1

            mux21 cl1 (b1[k],b2[k],s[0],y[k]);

        end
    endgenerate
endmodule

module mux21(a,b,s,o);
    input a,b,s;
    output reg o;
    always@(*)
    begin
        o = (a&~s) | (b&s);
    end
endmodule