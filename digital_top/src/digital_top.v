module digital_top (
    // Input signals
    input wire i_reset,
    input wire i_sys_clk,
    input wire i_dem_dis,  // input signal to disable vector rotation

    // Output signals    
    output reg [9:0] o_cs_cell_hi,  // CS cell MSB DAC                    
    output reg [9:0] o_cs_cell_lo   // CS cell LSB DAC          
);

    // Counters
    reg [4:0] ring_cnt;  // Counter for output selection

    // Unit vectors
    reg [9:0] unit_vector_H [0:3]; // Array for high unit vectors
    reg [9:0] unit_vector_L [0:3]; // Array for low unit vectors

    // Initialize unit vectors
    always @(posedge i_sys_clk or posedge i_reset) begin
        if (i_reset) begin
            // Reset the counters and outputs
            ring_cnt <= 5'b0;
            o_cs_cell_hi <= 10'b0;
            o_cs_cell_lo <= 10'b0;

            // Initialize unit vectors
            unit_vector_H[0] <= 10'b1100000000;
            unit_vector_H[1] <= 10'b1111100000;
            unit_vector_H[2] <= 10'b1111111100;
            unit_vector_H[3] <= 10'b1111111111;
            
            unit_vector_L[0] <= 10'b1000000000;
            unit_vector_L[1] <= 10'b1111100000;
            unit_vector_L[2] <= 10'b1111111110;
            unit_vector_L[3] <= 10'b1111111111;
        end else begin
            // Update ring counter
            ring_cnt <= (ring_cnt == 5'd9) ? 5'b0 : ring_cnt + 1;            

            // Update unit vectors and outputs based on ring counter
            case (ring_cnt)
                5'd0, 5'd9: begin
                    o_cs_cell_hi <= 10'b0;
                    o_cs_cell_lo <= 10'b0;
                end
                5'd1, 5'd8: begin
                    if (!i_dem_dis) begin // Check if i_dem_dis is low
                        // Shift the unit vectors
                        unit_vector_H[0] <= {unit_vector_H[0][8:0], unit_vector_H[0][9]};
                        unit_vector_L[0] <= {unit_vector_L[0][8:0], unit_vector_L[0][9]};
                    end
                    o_cs_cell_hi <= unit_vector_H[0];
                    o_cs_cell_lo <= unit_vector_L[0];
                end
                5'd2, 5'd7: begin
                    if (!i_dem_dis) begin // Check if i_dem_dis is low
                        // Shift the unit vectors
                        unit_vector_H[1] <= {unit_vector_H[1][8:0], unit_vector_H[1][9]};
                        unit_vector_L[1] <= {unit_vector_L[1][8:0], unit_vector_L[1][9]};
                    end
                    o_cs_cell_hi <= unit_vector_H[1];
                    o_cs_cell_lo <= unit_vector_L[1];
                end
                5'd3, 5'd6: begin
                    if (!i_dem_dis) begin // Check if i_dem_dis is low
                        // Shift the unit vectors
                        unit_vector_H[2] <= {unit_vector_H[2][8:0], unit_vector_H[2][9]};
                        unit_vector_L[2] <= {unit_vector_L[2][8:0], unit_vector_L[2][9]};
                    end
                    o_cs_cell_hi <= unit_vector_H[2];
                    o_cs_cell_lo <= unit_vector_L[2];
                end
                5'd4, 5'd5: begin
                    if (!i_dem_dis) begin // Check if i_dem_dis is low
                        // Shift the unit vectors
                        unit_vector_H[3] <= {unit_vector_H[3][8:0], unit_vector_H[3][9]};
                        unit_vector_L[3] <= {unit_vector_L[3][8:0], unit_vector_L[3][9]};
                    end
                    o_cs_cell_hi <= unit_vector_H[3];
                    o_cs_cell_lo <= unit_vector_L[3];
                end
                default: begin
                    o_cs_cell_hi <= 10'b0;
                    o_cs_cell_lo <= 10'b0;
                end
            endcase
        end
    end

endmodule

