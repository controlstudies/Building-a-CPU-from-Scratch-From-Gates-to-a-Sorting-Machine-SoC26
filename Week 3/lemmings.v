// There are 2 states involved : LEFT, RIGHT denoting which direction lemming is walking 
module lemmings_1(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); //  

     parameter LEFT=0, RIGHT=1;
    reg state, next_state;

    always @(*) begin
        // State transition logic
        case (state)
        LEFT : next_state <= bump_left ? RIGHT : LEFT;
        RIGHT : next_state <= bump_right ? LEFT : RIGHT;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) begin state = LEFT;end
        else state <= next_state;
    end

    // Output logic
    // assign walk_left = (state == ...);
    // assign walk_right = (state == ...);
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule

// there are 4 states in this Fsm:
//WALK_L (0): The lemming is walking to the left on solid ground.
// WALK_R (1): The lemming is walking to the right on solid ground.
// FALL_L (2): The lemming is falling through the air,before this he was walking in leftward direction
// FALL_R (3): The lemming is falling through the air,before this he was walking in rightward direction
module lemmings_2(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 

    parameter WALK_L = 0, WALK_R = 1, FALL_L = 2, FALL_R = 3;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            WALK_L: 
                if (!ground) next_state = FALL_L;
                else if (bump_left) next_state = WALK_R;
                else next_state = WALK_L;
                
            WALK_R: 
                if (!ground) next_state = FALL_R;
                else if (bump_right) next_state = WALK_L;
                else next_state = WALK_R;
            // Bumps are ignored while falling     
            FALL_L: 
                if (ground) next_state = WALK_L;
                else next_state = FALL_L; 
                
            FALL_R: 
                if (ground) next_state = WALK_R;
                else next_state = FALL_R;
                
            default: next_state = WALK_L;
        endcase
    end

    always @(posedge clk or posedge areset) begin 
        if (areset) begin 
            state <= WALK_L; 
        end else begin 
            state <= next_state;
        end
    end
    assign walk_left  = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah       = (state == FALL_L) || (state == FALL_R);

endmodule
// this fsm has 6 states :
// digl and digr: lemming is digging currently remembering the direction they were walking in prior to this
// falll and fallr : lemming is currently falling remembering the direction they were walking in prior to this
// walkl and walkr : marking the state in which lemming is walking in the respective direction
module lemmings_3(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
	
    reg [2:0]state, next_state;
    parameter digl=0,digr=1,walkl=2,walkr=3,falll=4,fallr=5;
    always@(*)begin 
        case(state)
            digl :  begin next_state = ground ? digl : falll; end
            digr:  begin next_state = ground ? digr:fallr; end
            walkl : begin 
                if(!ground) next_state = falll;
                else if(dig) next_state = digl;
                else next_state = bump_left? walkr:walkl;
            end
             walkr : begin 
                    if(!ground) next_state = fallr;
                 else if(dig) next_state = digr;
                else next_state = bump_right? walkl:walkr;
            end
            falll : if(ground)next_state = walkl;
            fallr : if(ground)next_state = walkr;
        endcase
    end
    always@(posedge clk or posedge areset)begin 
        if(areset) state = walkl;
        else state <=next_state;     
    end
    assign aaah = (state == falll) || (state == fallr);
    assign walk_left = state == walkl;
    assign walk_right = state == walkr;
    assign digging = (state == digr) || (state == digl);
endmodule

// This FSM has 7 states:
// walkl (2) / walkr (3): Walking left or right on solid ground.
// digl (0) / digr (1): Digging downward, remembering previous direction.
// falll (4) / fallr (5): Falling through the air. These states now act as active timers counting how many clock cycles the lemming has been airborne.
// dead (6): Terminal state. The lemming splats and remains in this state after landing on the ground after falling for more than 20 clk cycles
module lemmings_4(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging 
); 
    
    reg [2:0] state, next_state;
    reg [9:0] count; 
    parameter digl=0, digr=1, walkl=2, walkr=3, falll=4, fallr=5, dead=6;
    
    always @(*) begin 
        next_state = state; 
        
        case(state)
            digl  : next_state = ground ? digl : falll;
            digr  : next_state = ground ? digr : fallr;
            walkl : begin 
                if(!ground) next_state = falll;
                else if(dig) next_state = digl;
                else next_state = bump_left ? walkr : walkl;
            end
            walkr : begin 
                if(!ground) next_state = fallr;
                else if(dig) next_state = digr;
                else next_state = bump_right ? walkl : walkr;
            end
            falll : begin 
                if(ground) 
                    next_state = (count > 19) ? dead : walkl;
                else 
                    next_state = falll; 
            end
            fallr : begin 
                if(ground) 
                    next_state = (count > 19) ? dead : walkr;
                else 
                    next_state = fallr; 
            end
            dead  : next_state = dead; 
        endcase
    end
    
    always @(posedge clk or posedge areset) begin 
        if(areset) begin 
            state <= walkl; // 
            count <= 0; 
        end
        else begin 
            state <= next_state; 
            if(state == fallr || state == falll) 
                count <= count + 1; // Use non-blocking <=
            else
                count <= 0;
        end      
    end
    assign aaah = (state == falll) || (state == fallr);
    assign walk_left = (state == walkl);
    assign walk_right = (state == walkr);
    assign digging = (state == digr) || (state == digl);
    
endmodule
