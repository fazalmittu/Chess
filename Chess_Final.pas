program chess;
{*********************************************************************
*  Student Name: Fazal Mittu                                         *
*  Class: 8A                                                         *
*  Lab #: CPU FAIR                                                   *
*  Program description: CPU FAIR: Chess, a strategy game coded using
                        multiple 2D arrays to simulate legal attacks
                        and moves the player can make. This game is
                        2-player and allows 40 moves for each player.
                        The game ends when a player is in check two
                        times in a row.                              *
*********************************************************************}

{Declarations section e.g., Constants and Variables}
uses crt;
type
   board = array[1..8, 1..8] of char;

var
   chess_board : board;
   options : board;
   attack_options : board;
   move, attack : boolean;
   trial : char;
   b : boolean;
   m : boolean;
   n : integer;
   checker_w, checker_b : integer;
   check_num_w, check_num_b : integer;

procedure reset_values; //this procedure resets the values for all the attack_options/move_options; it is called after every move
   var
      i, j : integer;
   begin
      for i := 1 to 8 do
         for j := 1 to 8 do
            begin
               attack_options[i,j] := ' ';
               options[i,j] := ' ';
            end;
      move := false;
      attack := false;
      m := false;
   end;

procedure assign_pieces; //this procedure is used once in the beginning to assign the pieces to their corresponding array index
   var
      i,j : integer;
   begin
      //TOP ROW - RED TEAM

      chess_board[1,1] := 'r';
      chess_board[1,2] := 'b';
      chess_board[1,3] := 'q';
      chess_board[1,4] := 'k';
      chess_board[1,5] := 'b';
      chess_board[1,6] := 'r';

      //BOTTOM ROW - BLUE TEAM

      chess_board[8,1] := 'R';
      chess_board[8,2] := 'B';
      chess_board[8,3] := 'Q';
      chess_board[8,4] := 'K';
      chess_board[8,5] := 'B';
      chess_board[8,6] := 'R';

      for i := 1 to 6 do //RED PAWNS
         chess_board[2,i] := 'p';

      for i := 1 to 6 do //BLUE PAWNS
         chess_board[7,i] := 'P';

      for i := 3 to 6 do //FILLS ALL THE EMPTY SPACES WITH ' '
         begin
            for j := 1 to 6 do
               begin
                  chess_board[i,j] := ' ';
               end;
         end;

      for i := 1 to 8 do //FILLS THE OPTIONS AND ATTACK_OPTIONS ARRAY WITH ' '
         begin
            for j := 1 to 6 do
               begin
                  options[i,j] := ' ';
                  attack_options[i,j] := ' ';
               end;
         end;

   end;



procedure pawn(var x,y : integer; c : char); //this procedure is for the pawn piece; it is able to find any valid moves or attacks
                                             //if it finds a valid move, it sets the 'move' variable true
                                             //if it finds a valid attack, it sets the 'attack' variable true and stores that attack in an array
   var
      attack_1 : char;
      attack_2 : char;

   begin
      case c of
         'W' : begin
                  if chess_board[x+1,y] = ' ' then //this checks if the space ahead of it is open
                     begin
                        move := true;
                        options[x+1,y] := 'T';
                     end
                  else
                     move := false;

                  if x = 2 then
                     if chess_board[x+2,y] = ' ' then //this checks if the space ahead of it is open
                        begin
                           move := true;
                           options[x+2,y] := 'T';
                        end
                     else
                        move := false;

                  attack_1 := chess_board[x+1,y+1]; //attack 1 and 2 are the two possible attacks a pawn may have(diagonal right and left)
                  attack_2 := chess_board[x+1,y-1];
                  case attack_1 of
                     'R', 'B', 'Q', 'K', 'P' : begin
                                                   attack := true;
                                                   attack_options[x+1,y+1] := 'T';
                                                   //if chess_board[x+1,y+1] := 'K' then attack_options[x+1,y+1] := ' ';
                                               end;
                  end;

                  case attack_2 of
                     'R', 'B', 'Q', 'K', 'P' : begin
                                                   attack := true;
                                                   attack_options[x+1,y-1] := 'T';
                                                   //if chess_board[x+1,y+1] := 'K' then attack_options[x+1,y+1] := ' ';
                                               end;
                  end;

               end;

         'B' : begin
                  if chess_board[x-1,y] = ' ' then
                     begin
                        move := true;
                        options[x-1,y] := 'T';
                     end
                  else
                     begin
                        move := false;
                     end;

                 if x = 7 then
                    if chess_board[x-2,y] = ' ' then
                       begin
                          move := true;
                          options[x-2,y] := 'T';
                       end
                    else
                       begin
                          move := false;
                       end;

                  attack_1 := chess_board[x-1,y+1];
                  attack_2 := chess_board[x-1,y-1];
                  case attack_1 of
                     'r', 'b', 'q', 'k', 'p' : begin
                                                   attack := true;
                                                   attack_options[x-1,y+1] := 'T';
                                                   //if chess_board[x+1,y+1] := 'k' then attack_options[x+1,y+1] := ' ';
                                               end;
                  end;

                  case attack_2 of
                     'r', 'b', 'q', 'k', 'p' : begin
                                                   attack := true;
                                                   attack_options[x-1,y-1] := 'T';
                                                   //if chess_board[x+1,y+1] := 'k' then attack_options[x+1,y+1] := ' ';
                                               end;
                  end;

               end;


      end;

   end;

procedure bishop(var x, y : integer; c : char); //this procedure is for the bishop piece; it is able to find any valid moves or attacks
                                                //if it finds a valid move, it sets the 'move' variable true
                                                //if it finds a valid attack, it sets the 'attack' variable true and stores that attack in an array
   var
      i : integer;
      attack_1, attack_2 : char;

   begin
      case c of
         'W' : begin
                  //the next 4 procedures check the moves for the bishop
                  //it keeps checking for open spaces until the value it checks is not empty (meaning it has encountered a piece)

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x-i, y-i] = ' ' then
                        begin
                           move := true;
                           options[x-i, y-i] := 'T';
                        end;
                     //i := i+1;
                  until (chess_board[x-i, y-i] <> ' ') {or (x <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x+i, y+i] = ' ' then
                        begin
                           move := true;
                           options[x+i, y+i] := 'T';
                        end;
                     //i := i+1;
                  until (chess_board[x+i, y+i] <> ' ') or (x > 8);

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x-i, y+i] = ' ' then
                        begin
                           move := true;
                           options[x-i, y+i] := 'T';
                        end;
                     //i := i+1;
                  until (chess_board[x-i, y+i] <> ' ') or (x < 1);

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x+i, y-i] = ' ' then
                        begin
                           move := true;
                           options[x+i, y-i] := 'T';
                        end;
                     //i := i+1;
                  until (chess_board[x+i, y-i] <> ' ') or (x > 8);

                  //the next 4 procedures check the attacks for the bishop
                  //it keeps checking for enemy pieces until the value it checks is not empty (meaning it has encountered a piece)
                  //or until the board ends

                  i := 0;
                  repeat
                     i := i+1;
                     attack_1 := chess_board[x-i, y-i];
                     //if x >= 2 then
                        case attack_1 of
                             'R', 'B', 'Q', 'K', 'P' : begin
                                                            attack := true;
                                                            attack_options[x-i, y-i] := 'T';
                                                            //if chess_board[x-i,y-i] := 'K' then attack_options[x-i,y-i] := ' ';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x-i, y-i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y > 6)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x+i, y+i];
                     //if x <= 7 then
                        case attack_2 of
                             'R', 'B', 'Q', 'K', 'P' : begin
                                                            attack := true;
                                                            attack_options[x+i, y+i] := 'T';
                                                            //if chess_board[x-i,y-i] := 'K' then attack_options[x-i,y-i] := ' ';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x+i, y+i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_1 := chess_board[x-i, y+i];
                     //if x >= 2 then
                        case attack_1 of
                             'R', 'B', 'Q', 'K', 'P' : begin
                                                            attack := true;
                                                            attack_options[x-i, y+i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x-i, y+i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x+i, y-i];
                     //if x <= 7 then
                        case attack_2 of
                             'R', 'B', 'Q', 'K', 'P' : begin
                                                            attack := true;
                                                            attack_options[x+i, y-i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x+i, y-i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

               end;




         'B' : begin  //these loops are the same as above; except for the other team
                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x-i, y-i] = ' ' then
                        begin
                           move := true;
                           options[x-i, y-i] := 'T';
                        end;
                     //i := i+1;
                  until (chess_board[x-i, y-i] <> ' ') {or (x <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     if x+i < 8 then
                        if chess_board[x+i, y+i] = ' ' then
                           begin
                                move := true;
                                options[x+i, y+i] := 'T';
                           end;
                     //i := i+1;
                  until (chess_board[x+i, y+i] <> ' ') {or (x >= 8)};

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x-i, y+i] = ' ' then
                        begin
                           move := true;
                           options[x-i, y+i] := 'T';
                        end;
                     //i := i+1;
                  until (chess_board[x-i, y+i] <> ' ') {or (x <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     if x+i < 8 then
                        if chess_board[x+i, y-i] = ' ' then
                           begin
                                move := true;
                                options[x+i, y-i] := 'T';
                           end;
                     //i := i+1;
                  until (chess_board[x+i, y-i] <> ' ') or (x > 8) or (x < 1) or (y > 6);

                  i := 0;
                  repeat
                     i := i+1;
                     attack_1 := chess_board[x-i, y-i];
                     //if x >= 2 then
                        case attack_1 of
                             'r', 'b', 'q', 'k', 'p' : begin
                                                            attack := true;
                                                            attack_options[x-i, y-i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x-i, y-i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x+i, y+i];
                     //if x <= 7 then
                        case attack_2 of
                             'r', 'b', 'q', 'k', 'p' : begin
                                                            attack := true;
                                                            attack_options[x+i, y+i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x+i, y+i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_1 := chess_board[x-i, y+i];
                     //if x >= 2 then
                        case attack_1 of
                             'r', 'b', 'q', 'k', 'p' : begin
                                                            attack := true;
                                                            attack_options[x-i, y+i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x-i, y+i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x+i, y-i];
                     //if x <= 7 then
                        case attack_2 of
                             'r', 'b', 'q', 'k', 'p' : begin
                                                            attack := true;
                                                            attack_options[x+i, y-i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x+i, y-i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};





               end;
      end;
   end;


procedure rook (var x,y : integer; c : char); //this procedure is for the rook piece; it is able to find any valid moves or attacks
                                              //if it finds a valid move, it sets the 'move' variable true
                                              //if it finds a valid attack, it sets the 'attack' variable true and stores that attack in an array
   var
      i : integer;
      attack_2 : char;

   begin
      case c of
           'W' : begin
                      //the next 4 procedures check the moves for the rook
                      //it keeps checking for open spaces until the value it checks is not empty (meaning it has encountered a piece)

                      i := 0;
                      repeat
                            i := i+1;
                            if chess_board[x-i, y] = ' ' then
                               begin
                                    move := true;
                                    options[x-i, y] := 'T';
                               end;

                      until (chess_board[x-i, y] <> ' ') or (x < 1);

                      i := 0;
                      repeat
                            i := i+1;
                            if chess_board[x+i, y] = ' ' then
                               begin
                                    move := true;
                                    options[x+i, y] := 'T';
                               end;

                      until (chess_board[x+i, y] <> ' ') or (x > 8);

                      i := 0;
                      repeat
                            i := i+1;
                            if chess_board[x, y-i] = ' ' then
                               begin
                                    move := true;
                                    options[x, y-i] := 'T';
                               end;
                      until (chess_board[x, y-i] <> ' ') or (y < 1);

                      i := 0;
                      repeat
                            i := i+1;
                            if chess_board[x, y+i] = ' ' then
                               begin
                                    move := true;
                                    options[x, y+i] := 'T';
                               end;

                      until (chess_board[x, y+i] <> ' ') or (y > 8);

                      //the next 4 procedures check the attacks for the rook
                      //it keeps checking for enemy pieces until the value it checks is not empty (meaning it has encountered a piece)
                      //or until the board ends

                      i := 0;
                      repeat
                            i := i+1;
                            attack_2 := chess_board[x-i, y];
                            //if x <= 7 then
                            case attack_2 of
                                 'R', 'B', 'Q', 'K', 'P' : begin
                                                                attack := true;
                                                                attack_options[x-i, y] := 'T';
                                                           end;
                            end;
                            //i := i+1;

                      until (chess_board[x-i, y] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};


                      i := 0;
                      repeat
                            i := i+1;
                            attack_2 := chess_board[x+i, y];
                            //if x <= 7 then
                            case attack_2 of
                                 'R', 'B', 'Q', 'K', 'P' : begin
                                                                attack := true;
                                                                attack_options[x+i, y] := 'T';
                                                           end;
                            end;
                            //i := i+1;

                      until (chess_board[x+i, y] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                      i := 0;
                      repeat
                            i := i+1;
                            attack_2 := chess_board[x, y-i];
                            //if x <= 7 then
                            case attack_2 of
                                 'R', 'B', 'Q', 'K', 'P' : begin
                                                                attack := true;
                                                                attack_options[x, y-i] := 'T';
                                                           end;
                            end;
                            //i := i+1;

                      until (chess_board[x, y-i] <> ' ') or (x > 8) or (x < 1) or (y < 1) {or (y <= 1)};


                      i := 0;
                      repeat
                            i := i+1;
                            attack_2 := chess_board[x, y+i];
                            //if x <= 7 then
                            case attack_2 of
                                 'R', 'B', 'Q', 'K', 'P' : begin
                                                                attack := true;
                                                                attack_options[x, y+i] := 'T';
                                                           end;
                            end;
                            //i := i+1;

                      until (chess_board[x, y+i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};




                 end;
           'B' : begin //these loops are the same as above; except for the other team
                      i := 0;
                      repeat
                            i := i+1;
                            if chess_board[x-i, y] = ' ' then
                               begin
                                    move := true;
                                    options[x-i, y] := 'T';
                               end;

                      until (chess_board[x-i, y] <> ' ') or (x < 1);

                      i := 0;
                      repeat
                            i := i+1;
                            if x+i < 8 then
                               if chess_board[x+i, y] = ' ' then
                                  begin
                                       move := true;
                                       options[x+i, y] := 'T';
                                  end;

                      until (chess_board[x+i, y] <> ' ') or (x > 8);

                      i := 0;
                      repeat
                            i := i+1;
                            if chess_board[x, y-i] = ' ' then
                               begin
                                    move := true;
                                    options[x, y-i] := 'T';
                               end;
                      until (chess_board[x, y-i] <> ' ') or (y < 1);

                      i := 0;
                      repeat
                            i := i+1;
                            if chess_board[x, y+i] = ' ' then
                               begin
                                    move := true;
                                    options[x, y+i] := 'T';
                               end;

                      until (chess_board[x, y+i] <> ' ') or (y > 8);

                      i := 0;
                      repeat
                            i := i+1;
                            attack_2 := chess_board[x-i, y];
                            //if x <= 7 then
                            case attack_2 of
                                 'r', 'b', 'q', 'k', 'p' : begin
                                                                attack := true;
                                                                attack_options[x-i, y] := 'T';
                                                           end;
                            end;
                            //i := i+1;

                      until (chess_board[x-i, y] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                      i := 0;
                      repeat
                            i := i+1;
                            attack_2 := chess_board[x+i, y];
                            //if x <= 7 then
                            case attack_2 of
                                 'r', 'b', 'q', 'k', 'p' : begin
                                                                attack := true;
                                                                attack_options[x+i, y] := 'T';
                                                           end;
                            end;
                            //i := i+1;

                      until (chess_board[x+i, y] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                      i := 0;
                      repeat
                            i := i+1;
                            attack_2 := chess_board[x, y-i];
                            //if x <= 7 then
                            case attack_2 of
                                 'r', 'b', 'q', 'k', 'p' : begin
                                                                attack := true;
                                                                attack_options[x, y-i] := 'T';
                                                           end;
                            end;
                            //i := i+1;

                      until (chess_board[x, y-i] <> ' ') or (x > 8) or (x < 1) or (y < 1) {or (y <= 1)};


                      i := 0;
                      repeat
                            i := i+1;
                            attack_2 := chess_board[x, y+i];
                            //if x <= 7 then
                            case attack_2 of
                                 'r', 'b', 'q', 'k', 'p' : begin
                                                                attack := true;
                                                                attack_options[x, y+i] := 'T';
                                                           end;
                            end;
                            //i := i+1;

                      until (chess_board[x, y+i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};
                 end;




      end;
    end;


procedure queen(var x,y : integer; c : char); //this procedure is for the queen piece; it is able to find any valid moves or attacks
                                              //if it finds a valid move, it sets the 'move' variable true
                                              //if it finds a valid attack, it sets the 'attack' variable true and stores that attack in an array
   var
      i : integer;
      attack_1, attack_2 : char;

   begin
      case c of
         'W' : begin
                  //the next 8 procedures check the moves for the queen
                  //it keeps checking for open spaces until the value it checks is not empty (meaning it has encountered a piece)

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x-i, y-i] = ' ' then
                        begin
                           move := true;
                           options[x-i, y-i] := 'T';
                        end;
                     //i := i+1;
                  until (chess_board[x-i, y-i] <> ' ') {or (x <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x+i, y+i] = ' ' then
                        begin
                           move := true;
                           options[x+i, y+i] := 'T';
                        end;
                     //i := i+1;
                  until (chess_board[x+i, y+i] <> ' ') or (x > 8);

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x-i, y+i] = ' ' then
                        begin
                           move := true;
                           options[x-i, y+i] := 'T';
                        end;
                     //i := i+1;
                  until (chess_board[x-i, y+i] <> ' ') or (x < 1);

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x+i, y-i] = ' ' then
                        begin
                           move := true;
                           options[x+i, y-i] := 'T';
                        end;
                     //i := i+1;
                  until (chess_board[x+i, y-i] <> ' ') or (x > 8);

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x-i, y] = ' ' then
                        begin
                           move := true;
                           options[x-i, y] := 'T';
                        end;

                  until (chess_board[x-i, y] <> ' ') or (x < 1);

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x+i, y] = ' ' then
                        begin
                           move := true;
                           options[x+i, y] := 'T';
                        end;

                  until (chess_board[x+i, y] <> ' ') or (x > 8);

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x, y-i] = ' ' then
                        begin
                           move := true;
                           options[x, y-i] := 'T';
                        end;
                  until (chess_board[x, y-i] <> ' ') or (y < 1);

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x, y+i] = ' ' then
                        begin
                           move := true;
                           options[x, y+i] := 'T';
                        end;

                  until (chess_board[x, y+i] <> ' ') or (y > 8);

                  //the next 8 procedures check the attacks for the rook
                  //it keeps checking for enemy pieces until the value it checks is not empty (meaning it has encountered a piece)
                  //or until the board ends

                  i := 0;
                  repeat
                     i := i+1;
                     attack_1 := chess_board[x-i, y-i];
                     //if x >= 2 then
                        case attack_1 of
                             'R', 'B', 'Q', 'K', 'P' : begin
                                                            b := true;
                                                            attack := true;
                                                            attack_options[x-i, y-i] := 'T';
                                                       end;
                        end;

                     //i := i+1;

                  until (chess_board[x-i, y-i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y > 6)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x+i, y+i];
                     //if x <= 7 then
                        case attack_2 of
                             'R', 'B', 'Q', 'K', 'P' : begin
                                                            b := true;
                                                            attack := true;
                                                            attack_options[x+i, y+i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x+i, y+i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_1 := chess_board[x-i, y+i];
                     //if x >= 2 then
                        case attack_1 of
                             'R', 'B', 'Q', 'K', 'P' : begin
                                                            b := true;
                                                            attack := true;
                                                            attack_options[x-i, y+i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x-i, y+i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x+i, y-i];
                     //if x <= 7 then
                        case attack_2 of
                             'R', 'B', 'Q', 'K', 'P' : begin
                                                            b := true;
                                                            attack := true;
                                                            attack_options[x+i, y-i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x+i, y-i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x-i, y];
                     //if x <= 7 then
                        case attack_2 of
                             'R', 'B', 'Q', 'K', 'P' : begin
                                                            attack := true;
                                                            attack_options[x-i, y] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x-i, y] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};


                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x+i, y];
                     //if x <= 7 then
                        case attack_2 of
                             'R', 'B', 'Q', 'K', 'P' : begin
                                                            attack := true;
                                                            attack_options[x+i, y] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x+i, y] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x, y-i];
                     //if x <= 7 then
                        case attack_2 of
                             'R', 'B', 'Q', 'K', 'P' : begin
                                                            attack := true;
                                                            attack_options[x, y-i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x, y-i] <> ' ') or (x > 8) or (x < 1) or (y < 1) {or (y <= 1)};


                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x, y+i];
                     //if x <= 7 then
                        case attack_2 of
                             'R', 'B', 'Q', 'K', 'P' : begin
                                                            attack := true;
                                                            attack_options[x, y+i] := 'T';
                                                       end;
                        end;
                     //i := i+1;
                  
                  until (chess_board[x, y+i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};


               end;




         'B' : begin //these loops below are the same as above except for the other team
                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x-i, y-i] = ' ' then
                        begin
                           move := true;
                           options[x-i, y-i] := 'T';
                        end;
                     //i := i+1;
                  until (chess_board[x-i, y-i] <> ' ') {or (x <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     if x+i < 8 then
                        if chess_board[x+i, y+i] = ' ' then
                           begin
                                move := true;
                                options[x+i, y+i] := 'T';
                           end;
                     //i := i+1;
                  until (chess_board[x+i, y+i] <> ' ') {or (x >= 8)};

                  i := 0;
                  repeat
                     i := i+1;
                     if chess_board[x-i, y+i] = ' ' then
                        begin
                           move := true;
                           options[x-i, y+i] := 'T';
                        end;
                     //i := i+1;
                  until (chess_board[x-i, y+i] <> ' ') {or (x <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     if x+i < 8 then
                        if chess_board[x+i, y-i] = ' ' then
                           begin
                                move := true;
                                options[x+i, y-i] := 'T';
                           end;
                     //i := i+1;
                  until (chess_board[x+i, y-i] <> ' ') or (x > 8) or (x < 1) or (y > 6);

                  i := 0;
                  repeat
                     i := i+1;
                     //if x < 8 then
                        if chess_board[x-i, y] = ' ' then
                           begin
                                move := true;
                                options[x-i, y] := 'T';
                           end;

                  until (chess_board[x-i, y] <> ' ') or (x < 1);
                  
                  i := 0;
                  repeat
                     i := i+1;
                     if x+i < 8 then
                        if chess_board[x+i, y] = ' ' then
                           begin
                                move := true;
                                options[x+i, y] := 'T';
                           end;

                  until (chess_board[x+i, y] <> ' ') or (x > 8);

                  i := 0;
                  repeat
                     i := i+1;
                     if x < 8 then
                        if chess_board[x, y-i] = ' ' then
                           begin
                                move := true;
                                options[x, y-i] := 'T';
                           end;
                  until (chess_board[x, y-i] <> ' ') or (y < 1);
                  
                  i := 0;
                  repeat
                     i := i+1;
                     if x < 8 then
                        if chess_board[x, y+i] = ' ' then
                           begin
                                move := true;
                                options[x, y+i] := 'T';
                           end;

                  until (chess_board[x, y+i] <> ' ') or (y > 8);


                  i := 0;
                  repeat
                     i := i+1;
                     attack_1 := chess_board[x-i, y-i];
                     //if x >= 2 then
                        case attack_1 of
                             'r', 'b', 'q', 'k', 'p' : begin
                                                            b := true;
                                                            attack := true;
                                                            attack_options[x-i, y-i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x-i, y-i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x+i, y+i];
                     //if x < 7 then
                        case attack_2 of
                             'r', 'b', 'q', 'k', 'p' : begin
                                                            b := true;
                                                            attack := true;
                                                            attack_options[x+i, y+i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x+i, y+i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_1 := chess_board[x-i, y+i];
                     //if x >= 2 then
                        case attack_1 of
                             'r', 'b', 'q', 'k', 'p' : begin
                                                            b := true;
                                                            attack := true;
                                                            attack_options[x-i, y+i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x-i, y+i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x+i, y-i];
                     //if x+i < 8 then
                        case attack_2 of
                             'r', 'b', 'q', 'k', 'p' : begin
                                                            b := true;
                                                            attack := true;
                                                            attack_options[x+i, y-i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x+i, y-i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x-i, y];
                     //if x < 8 then
                        case attack_2 of
                             'r', 'b', 'q', 'k', 'p' : begin
                                                            attack := true;
                                                            attack_options[x-i, y] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x-i, y] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};


                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x+i, y];
                     //if x+i < 8 then
                        case attack_2 of
                             'r', 'b', 'q', 'k', 'p' : begin
                                                            attack := true;
                                                            attack_options[x+i, y] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x+i, y] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x, y-i];
                     //if x < 8 then
                        case attack_2 of
                             'r', 'b', 'q', 'k', 'p' : begin
                                                            attack := true;
                                                            attack_options[x, y-i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x, y-i] <> ' ') or (x > 8) or (x < 1) or (y < 1) {or (y <= 1)};
                  

                  i := 0;
                  repeat
                     i := i+1;
                     attack_2 := chess_board[x, y+i];
                     //if x < 8 then
                        case attack_2 of
                             'r', 'b', 'q', 'k', 'p' : begin
                                                            attack := true;
                                                            attack_options[x, y+i] := 'T';
                                                       end;
                        end;
                     //i := i+1;

                  until (chess_board[x, y+i] <> ' ') or (x > 8) or (x < 1) or (y > 6) {or (y <= 1)};

               end;
      end;
   end;


procedure king(var x, y : integer; c : char); //this procedure is for theking piece; it is able to find any valid moves or attacks
                                              //if it finds a valid move, it sets the 'move' variable true
                                              //if it finds a valid attack, it sets the 'attack' variable true and stores that attack in an array
   var
      i : integer;
      attack_1, attack_2 : char;

   begin
      case c of
         'W' : begin
                  //the next 8 procedures check the moves for the king
                  //it checks if the spaces around the king to see if they are open

                  i := 1;
                  if x > 1 then
                     if chess_board[x-i, y-i] = ' ' then
                        begin
                           move := true;
                           options[x-i, y-i] := 'T';
                        end;

                  if x < 8 then
                     if chess_board[x+i, y+i] = ' ' then
                        begin
                           move := true;
                           options[x+i, y+i] := 'T';
                        end;

                  if x > 1 then
                     if chess_board[x-i, y+i] = ' ' then
                        begin
                           move := true;
                           options[x-i, y+i] := 'T';
                        end;

                  if x < 8 then
                     if chess_board[x+i, y-i] = ' ' then
                        begin
                           move := true;
                           options[x+i, y-i] := 'T';
                        end;

                  if x > 1 then
                     if chess_board[x-i, y] = ' ' then
                        begin
                           move := true;
                           options[x-i, y] := 'T';
                        end;

                  if x < 8 then
                     if chess_board[x+i, y] = ' ' then
                        begin
                           move := true;
                           options[x+i, y] := 'T';
                        end;


                  if y > 1 then
                     if chess_board[x, y-i] = ' ' then
                        begin
                           move := true;
                           options[x, y-i] := 'T';
                        end;

                  if y < 8 then
                     if chess_board[x, y+i] = ' ' then
                        begin
                           move := true;
                           options[x, y+i] := 'T';
                        end;

                  //the next 8 moves are checking for attacks for the king
                  //the squares around it are stored in a variable 'attack' and a case statement checks if an enemy piece is in that index

                  attack_1 := chess_board[x-i, y-i];
                  case attack_1 of
                     'R', 'B', 'Q', 'K', 'P' : begin
                                                   b := true;
                                                   attack := true;
                                                   attack_options[x-i, y-i] := 'T';
                                               end;
                  end;

                  attack_2 := chess_board[x+i, y+i];
                  case attack_2 of
                     'R', 'B', 'Q', 'K', 'P' : begin
                                                   b := true;
                                                   attack := true;
                                                   attack_options[x+i, y+i] := 'T';
                                               end;
                  end;

                  attack_1 := chess_board[x-i, y+i];
                  case attack_1 of
                     'R', 'B', 'Q', 'K', 'P' : begin
                                                   b := true;
                                                   attack := true;
                                                   attack_options[x-i, y+i] := 'T';
                                               end;
                  end;

                  attack_2 := chess_board[x+i, y-i];
                  case attack_2 of
                     'R', 'B', 'Q', 'K', 'P' : begin
                                                   b := true;
                                                   attack := true;
                                                   attack_options[x+i, y-i] := 'T';
                                               end;
                  end;

                  attack_2 := chess_board[x-i, y];
                  case attack_2 of
                     'R', 'B', 'Q', 'K', 'P' : begin
                                                   attack := true;
                                                   attack_options[x-i, y] := 'T';
                                               end;
                  end;

                  attack_2 := chess_board[x+i, y];
                  case attack_2 of
                     'R', 'B', 'Q', 'K', 'P' : begin
                                                   attack := true;
                                                   attack_options[x+i, y] := 'T';
                                               end;
                  end;

                  attack_2 := chess_board[x, y-i];
                  case attack_2 of
                     'R', 'B', 'Q', 'K', 'P' : begin
                                                   attack := true;
                                                   attack_options[x, y-i] := 'T';
                                               end;
                  end;

                  attack_2 := chess_board[x, y+i];
                  case attack_2 of
                     'R', 'B', 'Q', 'K', 'P' : begin
                                                   attack := true;
                                                   attack_options[x, y+i] := 'T';
                                               end;
                  end;


               end;

         'B' : begin  //the loops below are the same as the ones above except for the other team
                  i := 1;
                  if x > 1 then
                     if chess_board[x-i, y-i] = ' ' then
                        begin
                           move := true;
                           options[x-i, y-i] := 'T';
                        end;

                  if x < 8 then
                     if chess_board[x+i, y+i] = ' ' then
                        begin
                           move := true;
                           options[x+i, y+i] := 'T';
                        end;

                  if x > 1 then
                     if chess_board[x-i, y+i] = ' ' then
                        begin
                           move := true;
                           options[x-i, y+i] := 'T';
                        end;

                  if x < 8 then
                     if chess_board[x+i, y-i] = ' ' then
                        begin
                           move := true;
                           options[x+i, y-i] := 'T';
                        end;

                  if x > 1 then
                     if chess_board[x-i, y] = ' ' then
                        begin
                           move := true;
                           options[x-i, y] := 'T';
                        end;

                  if x < 8 then
                     if chess_board[x+i, y] = ' ' then
                        begin
                           move := true;
                           options[x+i, y] := 'T';
                        end;


                  if y > 1 then
                     if chess_board[x, y-i] = ' ' then
                        begin
                           move := true;
                           options[x, y-i] := 'T';
                        end;

                  if y < 8 then
                     if chess_board[x, y+i] = ' ' then
                        begin
                           move := true;
                           options[x, y+i] := 'T';
                        end;

                  attack_1 := chess_board[x-i, y-i];
                  case attack_1 of
                     'r', 'b', 'q', 'k', 'p' : begin
                                                   b := true;
                                                   attack := true;
                                                   attack_options[x-i, y-i] := 'T';
                                               end;
                  end;

                  attack_2 := chess_board[x+i, y+i];
                  case attack_2 of
                     'r', 'b', 'q', 'k', 'p' : begin
                                                   b := true;
                                                   attack := true;
                                                   attack_options[x+i, y+i] := 'T';
                                               end;
                  end;

                  attack_1 := chess_board[x-i, y+i];
                  case attack_1 of
                     'r', 'b', 'q', 'k', 'p' : begin
                                                   b := true;
                                                   attack := true;
                                                   attack_options[x-i, y+i] := 'T';
                                               end;
                  end;

                  attack_2 := chess_board[x+i, y-i];
                  case attack_2 of
                     'r', 'b', 'q', 'k', 'p' : begin
                                                   b := true;
                                                   attack := true;
                                                   attack_options[x+i, y-i] := 'T';
                                               end;
                  end;

                  attack_2 := chess_board[x-i, y];
                  case attack_2 of
                     'r', 'b', 'q', 'k', 'p' : begin
                                                   attack := true;
                                                   attack_options[x-i, y] := 'T';
                                               end;
                  end;

                  attack_2 := chess_board[x+i, y];
                  case attack_2 of
                     'r', 'b', 'q', 'k', 'p' : begin
                                                   attack := true;
                                                   attack_options[x+i, y] := 'T';
                                               end;
                  end;

                  attack_2 := chess_board[x, y-i];
                  case attack_2 of
                     'r', 'b', 'q', 'k', 'p' : begin
                                                   attack := true;
                                                   attack_options[x, y-i] := 'T';
                                               end;
                  end;

                  attack_2 := chess_board[x, y+i];
                  case attack_2 of
                     'r', 'b', 'q', 'k', 'p' : begin
                                                   attack := true;
                                                   attack_options[x, y+i] := 'T';
                                               end;
                  end;


               end;
      end;
   end;


procedure make_board; //this procedure makes it so that the user can see the board while playing
                      //at the end of each move, the board gets refreshed and the values move according to where the user inputted
   var
      i,j : integer;
      piece : char;
      print : integer;

   begin
      textcolor(8);
      writeln;
      write('MOVE NUMBER: ', n); //the displays the move number in the top left corner
      write(' ' :14);
      for i := 1 to 6 do
         write(i :5);
      write(' - COLUMN'); //this shows the user where the column numbers are
      writeln;

      print := 0; //this variable is only in place so the user would know where the row numbers are

      for i := 1 to 8 do
         begin
            textcolor(8);
            writeln(' ' :28, '-------------------------------');
            if print = 0 then
               begin
                  write (' ' :19);
                  write('ROW - ');
               end
            else
               write(' ' :25);

            print := 1;
            write (i :3);
            write(' ', '|');
            for j := 1 to 6 do
               begin
                  piece := chess_board[i, j];
                  case piece of //this case statement makes it so each piece is printed in its respective color
                     'r', 'b', 'q', 'k', 'p' : textcolor(4);
                     'R', 'B', 'Q', 'K', 'P' : textcolor(1);

                  end;
                  write(chess_board[i,j] :3); //this prints the value down
                  textcolor(8);

                  write(' |');
               end;
            writeln;

         end;
       writeln(' ' :28, '-------------------------------');
       if checker_w = 1 then //this lets the user know when he or she is in check
          writeln('BLUE IS IN CHECK!');

       if checker_b = 1 then
          writeln('RED IS IN CHECK!');



   end;

procedure game_end(c : char); //this procedure is the screen after the game ends
   var
      i : integer;

   begin
      clrscr;
      case c of //the procedure is called with a parameter 'c' which tells the procedure which team won
         'W' : begin
                  for i := 1 to 5 do
                     writeln;
                  TextColor(4);
                  writeln(' ' :30, 'The winner is: RED TEAM');
                  delay(5000);
                  halt;

               end;
         'B' : begin
                  for i := 1 to 5 do
                     writeln;
                  TextColor(1);
                  writeln(' ' :30, 'The winner is: BLUE TEAM');
                  delay(5000);
                  halt;

               end;
         'D' : begin //this is displayed for a draw, or where each player has executed 40 moves
                  for i := 1 to 5 do
                     writeln;
                  TextColor(8);
                  writeln(' ' :26, 'THE GAME HAS ENDED IN A DRAW');
                  delay(5000);
                  halt;

               end;

      end;
   end;

procedure check; //this procedure is for check
                 //this procedure is run at the end of every move
   var
      i, j : integer;
      x, y : integer;
      piece : char;
      v1, v2 : integer;

   begin

      //in order for the game to end, there need to be 2 consecutive checks on the same player
      //checker_w and checker_b are the integers that are set to 1 when check is found
      //as the procedure is run at the end of every move, if it is already equal to 1, then check_num will be set to 1
      //this means that it is now checking for the second check in a row


      if checker_w = 1 then
         check_num_w := 1
      else
         check_num_w := 0;

      if checker_b = 1 then
         check_num_b := 1
      else
         check_num_b := 0;

      checker_w := 0;
      checker_b := 0;
      reset_values;

      //the following for loop is to check for each piece whether it has checked the king or not
      //it goes through the chess_board array and checks each index
      //based on what piece it is, it will run the procedure respective to the piece(for example for a pawn, it would run the procedure 'pawn')
      //if the variable attack is true, then it will go through another for loop
      //this for loop checks goes through the entire attack_options array; if the value of an index is equal to 'T'
      //it will check the value of the same index in the chess_board array and if the value is the enemy king
      //then it will see whether check_num equals to 1; if it does, then the game ends and it calls procedure game_end
      //otherwise, it will make the checker variable = 1

      for i := 1 to 8 do
          for j := 1 to 6 do
             begin
                reset_values;
                piece := chess_board[i, j];
                if piece <> ' ' then
                   v1 := i;
                   v2 := j;
                   case piece of
                      'p' : begin
                               pawn(v1, v2, 'W');
                               if attack = true then
                                  for x := 1 to 8 do
                                      for y := 1 to 6 do
                                         if attack_options[x, y] = 'T' then
                                            if chess_board[x, y] = 'K' then
                                               if check_num_w = 1 then
                                                  game_end('W')
                                               else
                                                  begin
                                                      checker_w := 1;
                                                      //attack_options[x, y] := ' ';
                                                  end;
                            end;

                      'b' : begin
                               bishop(v1, v2, 'W');
                               if attack = true then
                                  for x := 1 to 8 do
                                     for y := 1 to 6 do
                                        if attack_options[x, y] = 'T' then
                                           if chess_board[x, y] = 'K' then
                                              if check_num_w = 1 then
                                                  game_end('W')
                                              else
                                                  begin
                                                      checker_w := 1;
                                                      //attack_options[x, y] := ' ';
                                                  end;
                            end;

                      'r' : begin
                               rook(v1, v2, 'W');
                               if attack = true then
                                  for x := 1 to 8 do
                                     for y := 1 to 6 do
                                        if attack_options[x, y] = 'T' then
                                           if chess_board[x, y] = 'K' then
                                              if check_num_w = 1 then
                                                  game_end('W')
                                              else
                                                  begin
                                                      checker_w := 1;
                                                      //attack_options[x, y] := ' ';
                                                  end;
                            end;

                      'q' : begin
                               queen(v1, v2, 'W');
                               if attack = true then
                                  for x := 1 to 8 do
                                     for y := 1 to 6 do
                                        if attack_options[x, y] = 'T' then
                                           if chess_board[x, y] = 'K' then
                                              if check_num_w = 1 then
                                                  game_end('W')
                                              else
                                                  begin
                                                      checker_w := 1;
                                                      //attack_options[x, y] := ' ';
                                                  end;
                            end;

                      'k' : begin
                               king(v1, v2, 'W');
                               if attack = true then
                                  for x := 1 to 8 do
                                     for y := 1 to 6 do
                                        if attack_options[x, y] = 'T' then
                                           if chess_board[x, y] = 'K' then
                                              if check_num_w = 1 then
                                                  game_end('W')
                                              else
                                                  begin
                                                      checker_w := 1;
                                                      //attack_options[x, y] := ' ';
                                                  end;
                            end;

                     'P' : begin
                              pawn(v1, v2, 'B');
                              if attack = true then
                                 for x := 1 to 8 do
                                    for y := 1 to 6 do
                                       if attack_options[x, y] = 'T' then
                                          if chess_board[x, y] = 'k' then
                                             if check_num_b = 1 then
                                                game_end('B')
                                             else
                                                begin
                                                      checker_b := 1;
                                                      //attack_options[x, y] := ' ';
                                                end;
                           end;

                     'B' : begin
                              bishop(v1, v2, 'B');
                              if attack = true then
                                 for x := 1 to 8 do
                                    for y := 1 to 6 do
                                       if attack_options[x, y] = 'T' then
                                          if chess_board[x, y] = 'k' then
                                             if check_num_b = 1 then
                                                game_end('B')
                                             else
                                                begin
                                                      checker_b := 1;
                                                      //attack_options[x, y] := ' ';
                                                end;
                           end;

                     'R' : begin
                              rook(v1, v2, 'B');
                              if attack = true then
                              for x := 1 to 8 do
                                 for y := 1 to 6 do
                                    if attack_options[x, y] = 'T' then
                                       if chess_board[x, y] = 'k' then
                                          if check_num_b = 1 then
                                             game_end('B')
                                          else
                                             begin
                                                checker_b := 1;
                                                //attack_options[x, y] := ' ';
                                             end;
                           end;

                     'Q' : begin
                              queen(v1, v2, 'B');
                              if attack = true then
                                 for x := 1 to 8 do
                                    for y := 1 to 6 do
                                       if attack_options[x, y] = 'T' then
                                          if chess_board[x, y] = 'k' then
                                             if check_num_b = 1 then
                                                game_end('B')
                                             else
                                                begin
                                                      checker_b := 1;
                                                      //attack_options[x, y] := ' ';
                                                end;
                           end;

                     'K' : begin
                              king(v1, v2, 'B');
                              if attack = true then
                                 for x := 1 to 8 do
                                    for y := 1 to 6 do
                                       if attack_options[x, y] = 'T' then
                                          if chess_board[x, y] = 'k' then
                                             if check_num_b = 1 then
                                                game_end('B')
                                             else
                                                begin
                                                      checker_b := 1;
                                                      //attack_options[x, y] := ' ';
                                                end;
                           end;

                  end;
            end;
      end;


procedure prompt_piece(c : char); //this is the main procedure which prompts for the piece the user would like to move or attack with
                                  //this procedure controls everything including: resetting values, drawing the board, and checking for valid inputs
   var
      choice : char;
      x, y : integer;
      x1,y1 : integer;
      temp : char;
      am : char;
      i,j : integer;

   begin

      //this procedure controls the moves of each peice and is the one run at the beginnign of each move
      //it uses a case statement to determine what piece the user would like to move
      //if the piece is a pawn, bishop, or rook, it asks for the corrdinates of the one you would like to move(as there are multiple of those pieces)
      //it then runs the procedure according to the piece (for example: if I wanted to move a pawn with coordinates x and y, it would run
      //the proecdure pawn with parameters: x and y as well as c which is for the team)
      //this procedure gathers the possible moves/attacks for the piece
      //it will then prompt the user if they would like to attack a piece or just move it to another location
      //if it is attack, it will check if an attack is possible and displays the loctions you can attack
      //the user will have to choose one of the locations and the piece will be moved there
      //after that, the procedure runs the procedure check, which checks if any piece can attack the king
      //if a team is in check, it will display it on the board

      reset_values; //resets the values of the arrays so that the new piece the user would like to use has a fresh array
      clrscr;
      make_board;

      case c of
         'W' : textcolor(4);
         'B' : textcolor(1);
      end;
      repeat
         writeln('What piece would you like to move: ');
         readln(choice);
         clrscr;
         make_board;
         case c of
            'W' : textcolor(4);
            'B' : textcolor(1);
         end;
      until (choice = 'p') or (choice = 'P') or (choice = 'b') or (choice = 'B') or (choice = 'r') or (choice = 'R') or (choice = 'q') or (choice = 'Q') or (choice = 'k') or (choice = 'K');
      case choice of //this case statement tells the computer which piece it has to work with
         'P','p' : begin
                  case c of //this determines which team's turn it is
                        'W' : begin
                                 repeat
                                    writeln('Which pawn would you like to choose?');
                                    writeln('Enter 2 integers: ');
                                    write('ROW: ');
                                    readln(x);
                                    write('COLUMN: ');
                                    readln(y);
                                    writeln;

                                 until (chess_board[x,y] = 'p') and (y <= 6); //this repeat until asks for the coordinate of the pawn
                                                                              //that the user would like to move until a valid entry is entered

                                 pawn(x, y, c); //the procedure pawn is run to get the valid moves/attacks

                                 repeat //this repeat until checks if the user would like to attack or move the pawn
                                    writeln('Would you like to attack a piece or just move?');
                                    write('Enter ''a'' or ''m'': ');
                                    readln(am);
                                    if am <> 'a' then
                                       if am <> 'm' then
                                          writeln('Invalid Entry');

                                 until (am = 'a') or (am = 'm');

                                 case am of
                                    'a' : begin
                                             if attack = true then //checks if there are any valid attacks
                                                begin
                                                   for i :=  1 to 8 do
                                                      for j := 1 to 8 do
                                                         if attack_options[i,j] = 'T' then //displays the valid attacks the user can choose from
                                                            write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until attack_options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp; //moves the piece to where the user inputted
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible attacks for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('W');
                                                end;

                                          end;
                                    'm' : begin
                                             if move = true then
                                                begin
                                                   for i := 1 to 8 do
                                                      for j := 1 to 6 do
                                                         if options[i,j] = 'T' then
                                                            write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end

                                             else
                                                begin
                                                   writeln('Sorry you cannot move this pawn!');
                                                   delay(1000);
                                                   prompt_piece('W');
                                                end;
                                          end;
                                 end;

                                 {if (move <> true) and (attack <> true) then
                                    begin
                                       writeln('Sorry, you can''t do anything with this pawn!');
                                       delay(3000);
                                       clrscr;
                                       prompt_piece('W');
                                    end; }

                              end;

                        'B' : begin //same as above except for other team
                                 repeat
                                    writeln('Which pawn would you like to choose?');
                                    writeln('Enter 2 integers: ');
                                    write('ROW: ');
                                    readln(x);
                                    write('COLUMN: ');
                                    readln(y);
                                    writeln;

                                 until (chess_board[x,y] = 'P') and (y <= 6);

                                 pawn(x, y, c);
                                 repeat
                                    writeln('Would you like to attack a piece or just move?');
                                    write('Enter ''a'' or ''m'': ');
                                    readln(am);
                                    if am <> 'a' then
                                       if am <> 'm' then
                                          writeln('Invalid Entry');

                                 until (am = 'a') or (am = 'm');

                                 case am of
                                    'a' : begin
                                             if attack = true then
                                                begin
                                                   for i :=  1 to 8 do
                                                      for j := 1 to 8 do
                                                         if attack_options[i,j] = 'T' then
                                                            write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until attack_options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible attacks for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('B');
                                                end;

                                          end;
                                    'm' : begin
                                             if move = true then
                                                begin
                                                   for i := 1 to 8 do
                                                      for j := 1 to 6 do
                                                         if options[i,j] = 'T' then
                                                            write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end

                                             else
                                                begin
                                                   writeln('Sorry you cannot move this pawn!');
                                                   delay(1000);
                                                   prompt_piece('B');
                                                end;
                                          end;
                                 end;

                                 {if (move <> true) and (attack <> true) then
                                    begin
                                       writeln('Sorry, you can''t do anything with this pawn!');
                                       delay(3000);
                                       clrscr;
                                       prompt_piece('B');
                                    end; }


                              end;
                  end;

                  clrscr;
                  //make_board;

               end;
         'B','b' : begin
                  case c of
                     'W' : begin
                              for i := 1 to 8 do
                                 for j := 1 to 6 do
                                    if (chess_board[i, j] = 'b') then
                                       m := true;


                              if m <> true then
                                 begin
                                    writeln('This piece is gone! Please choose another');
                                    prompt_piece('W');
                                 end;

                              repeat
                                 writeln('Which bishop would you like to choose?');
                                 writeln('Enter 2 integers: ');
                                 write('ROW: ');
                                 readln(x);
                                 write('COLUMN: ');
                                 readln(y);
                                 writeln;
                              until (chess_board[x,y] = 'b') and (y <= 6); //this repeat until asks what bishop the user would like to move

                              bishop(x, y, c); //gathers all valid moves/attacks for given bishop

                              repeat
                                    writeln('Would you like to attack a piece or just move?');

                                    write('Enter ''a'' or ''m'': ');

                                    readln(am);
                                    if am <> 'a' then
                                       if am <> 'm' then
                                          writeln('Invalid Entry');

                              until (am = 'a') or (am = 'm');



                              case am of
                                    'a' : begin
                                             if attack = true then
                                                begin
                                                   for i :=  1 to 8 do
                                                      for j := 1 to 6 do
                                                         if attack_options[i,j] = 'T' then
                                                            if i+j = x+y then
                                                               write('(',i,', ',j,')', ' ')
                                                            else
                                                               if i-j = x-y then
                                                               write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until attack_options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible attacks for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('W');
                                                end;
                                          end;


                                    'm' : begin
                                             if move = true then
                                                begin
                                                   for i := 1 to 8 do
                                                      for j := 1 to 6 do
                                                         if options[i,j] = 'T' then
                                                            write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible moves for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('W');
                                                end;
                                          end;

                              end;

                              {if (move <> true) and (attack <> true) then
                                    begin
                                       writeln('Sorry, you can''t do anything with this bishop!');
                                       delay(3000);
                                       clrscr;
                                       prompt_piece('W');
                                    end;}
                           end;

                     'B' : begin //same as above except for other team
                              for i := 1 to 8 do
                                 for j := 1 to 6 do
                                    if (chess_board[i, j] = 'B') then
                                       m := true;


                              if m <> true then
                                 begin
                                    writeln('This piece is gone! Please choose another');
                                    prompt_piece('B');
                                 end;

                              repeat
                                 writeln('Which bishop would you like to choose?');
                                 writeln('Enter 2 integers: ');
                                 write('ROW: ');
                                 readln(x);
                                 write('COLUMN: ');
                                 readln(y);
                                 writeln;

                              until (chess_board[x,y] = 'B') and (y <= 6);
                              reset_values;
                              bishop(x, y, c);

                              repeat
                                    writeln('Would you like to attack a piece or just move?');
                                    write('Enter ''a'' or ''m'': ');
                                    readln(am);
                                    if am <> 'a' then
                                       if am <> 'm' then
                                          writeln('Invalid Entry');

                              until (am = 'a') or (am = 'm');

                              case am of
                                    'a' : begin
                                             if attack = true then
                                                begin
                                                   for i :=  1 to 8 do
                                                      for j := 1 to 6 do
                                                         if attack_options[i,j] = 'T' then
                                                            if i+j = x+y then
                                                               write('(',i,', ',j,')', ' ')
                                                            else
                                                               if i-j = x-y then
                                                                  write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until attack_options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible attacks for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('B');
                                                end;
                                          end;


                                    'm' : begin
                                             if move = true then
                                                begin
                                                   for i := 1 to 8 do
                                                      for j := 1 to 6 do
                                                         if options[i,j] = 'T' then
                                                            write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible moves for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('B');
                                                end;
                                          end;
                              end;

                              {if (move <> true) and (attack <> true) then
                                    begin
                                       writeln('Sorry, you can''t do anything with this bishop!');
                                       delay(3000);
                                       clrscr;
                                       prompt_piece('B');
                                    end; }

                           end;
                  end;
               end;
         'R','r' : begin
                  case c of
                     'W' : begin
                              for i := 1 to 8 do
                                 for j := 1 to 6 do
                                    if (chess_board[i, j] = 'r') then
                                       m := true;


                              if m <> true then
                                 begin
                                    writeln('This piece is gone! Please choose another');
                                    prompt_piece('W');
                                 end;

                              repeat
                                 writeln('Which rook would you like to choose?');
                                 writeln('Enter 2 integers: ');
                                 write('ROW: ');
                                 readln(x);
                                 write('COLUMN: ');
                                 readln(y);
                                 writeln;

                              until (chess_board[x,y] = 'r') and (y <= 6);
                              reset_values;
                              rook(x, y, c);

                              repeat
                                    writeln('Would you like to attack a piece or just move?');

                                    write('Enter ''a'' or ''m'': ');

                                    readln(am);
                                    if am <> 'a' then
                                       if am <> 'm' then
                                          writeln('Invalid Entry');

                              until (am = 'a') or (am = 'm');



                              case am of
                                    'a' : begin
                                             if attack = true then
                                                begin
                                                   for i :=  1 to 8 do
                                                      for j := 1 to 6 do
                                                         if attack_options[i,j] = 'T' then
                                                               write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until attack_options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible attacks for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('W');
                                                end;
                                          end;


                                    'm' : begin
                                             if move = true then
                                                begin
                                                   for i := 1 to 8 do
                                                      for j := 1 to 6 do
                                                         if options[i,j] = 'T' then
                                                            write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible moves for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('W');
                                                end;
                                          end;

                              end;

                              {if (move <> true) and (attack <> true) then
                                    begin
                                       writeln('Sorry, you can''t do anything with this rook!');
                                       delay(3000);
                                       clrscr;
                                       prompt_piece('W');
                                    end;  }
                           end;

                     'B' : begin
                              for i := 1 to 8 do
                                 for j := 1 to 6 do
                                    if (chess_board[i, j] = 'R') then
                                       m := true;


                              if m <> true then
                                 begin
                                    writeln('This piece is gone! Please choose another');
                                    prompt_piece('B');
                                 end;

                              repeat
                                 writeln('Which rook would you like to choose?');
                                 writeln('Enter 2 integers: ');
                                 write('ROW: ');
                                 readln(x);
                                 write('COLUMN: ');
                                 readln(y);
                                 writeln;
                              until (chess_board[x,y] = 'R') and (y <= 6);
                              reset_values;
                              rook(x, y, c);

                              repeat
                                    writeln('Would you like to attack a piece or just move?');
                                    write('Enter ''a'' or ''m'': ');
                                    readln(am);
                                    if am <> 'a' then
                                       if am <> 'm' then
                                          writeln('Invalid Entry');

                              until (am = 'a') or (am = 'm');

                              case am of
                                   'a' : begin
                                             if attack = true then
                                                begin
                                                   for i :=  1 to 8 do
                                                      for j := 1 to 6 do
                                                         if attack_options[i,j] = 'T' then
                                                               write('(',i,', ',j,')', ' ');

                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until attack_options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible attacks for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('B');
                                                end;
                                          end;


                                    'm' : begin
                                             if move = true then
                                                begin
                                                   for i := 1 to 8 do
                                                      for j := 1 to 6 do
                                                         if options[i,j] = 'T' then
                                                            write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible moves for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('B');
                                                end;
                                          end;
                              end;

                             { if (move <> true) and (attack <> true) then
                                    begin
                                       writeln('Sorry, you can''t do anything with this rook!');
                                       delay(3000);
                                       clrscr;
                                       prompt_piece('B');
                                    end;     }

                           end;
                  end;
               end;

         'Q','q' : begin
                  case c of
                     'W' : begin
                              for i := 1 to 8 do
                                 for j := 1 to 6 do
                                    if (chess_board[i, j] = 'q') then
                                       m := true;


                              if m <> true then
                                 begin
                                    writeln('This piece is gone! Please choose another');
                                    prompt_piece('W');
                                 end;

                              for i := 1 to 8 do
                                  for j := 1 to 6 do
                                      begin
                                           if chess_board[i, j] = 'q' then
                                              begin
                                                   x := i;
                                                   y := j;
                                              end;
                                     end;

                              queen(x, y, c);

                              repeat
                                    writeln('Would you like to attack a piece or just move?');

                                    write('Enter ''a'' or ''m'': ');

                                    readln(am);
                                    if am <> 'a' then
                                       if am <> 'm' then
                                          writeln('Invalid Entry');

                              until (am = 'a') or (am = 'm');



                              case am of
                                    'a' : begin
                                             if attack = true then
                                                begin
                                                   for i :=  1 to 8 do
                                                      for j := 1 to 6 do
                                                         if attack_options[i,j] = 'T' then
                                                            if b = true then
                                                               if i+j = x+y then
                                                                  write('(',i,', ',j,')', ' ')
                                                               else
                                                                  if i-j = x-y then
                                                                      write('(',i,', ',j,')', ' ')
                                                            else
                                                                write('(',i,', ',j,')', ' ');


                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until attack_options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible attacks for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('W');
                                                end;
                                          end;


                                    'm' : begin
                                             if move = true then
                                                begin
                                                   for i := 1 to 8 do
                                                      for j := 1 to 6 do
                                                         if options[i,j] = 'T' then
                                                            write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible moves for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('W');
                                                end;
                                          end;

                              end;

                              {if (move <> true) and (attack <> true) then
                                    begin
                                       writeln('Sorry, you can''t do anything with this piece!');
                                       delay(3000);
                                       clrscr;
                                       prompt_piece('W');
                                    end; }
                           end;

                     'B' : begin
                              for i := 1 to 8 do
                                 for j := 1 to 6 do
                                    if (chess_board[i, j] = 'Q') then
                                       m := true;


                              if m <> true then
                                 begin
                                    writeln('This piece is gone! Please choose another');
                                    prompt_piece('B');
                                 end;

                              for i := 1 to 8 do
                                  for j := 1 to 6 do
                                      begin
                                           if chess_board[i, j] = 'Q' then
                                              begin
                                                   x := i;
                                                   y := j;
                                              end;
                                     end;

                              queen(x, y, c);

                              repeat
                                    writeln('Would you like to attack a piece or just move?');
                                    write('Enter ''a'' or ''m'': ');
                                    readln(am);
                                    if am <> 'a' then
                                       if am <> 'm' then
                                          writeln('Invalid Entry');

                              until (am = 'a') or (am = 'm');

                              case am of
                                    'a' : begin
                                             if attack = true then
                                                begin
                                                   for i :=  1 to 8 do
                                                      for j := 1 to 6 do
                                                         if attack_options[i,j] = 'T' then
                                                            if b = true then
                                                               if i+j = x+y then
                                                                  write('(',i,', ',j,')', ' ')
                                                               else
                                                                   if i-j = x-y then
                                                                      write('(',i,', ',j,')', ' ')
                                                            else
                                                                write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until attack_options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible attacks for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('B');
                                                end;
                                          end;


                                    'm' : begin
                                             if move = true then
                                                begin
                                                   for i := 1 to 8 do
                                                      for j := 1 to 6 do
                                                         if options[i,j] = 'T' then
                                                            write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible moves for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('B');
                                                end;
                                          end;
                              end;

                              {if (move <> true) and (attack <> true) then
                                    begin
                                       writeln('Sorry, you can''t do anything with this piece!');
                                       delay(3000);
                                       clrscr;
                                       prompt_piece('B');
                                    end; }

                           end;
                  end;
               end;

         'K','k' : begin
                  case c of
                     'W' : begin
                              for i := 1 to 8 do
                                 for j := 1 to 6 do
                                    if (chess_board[i, j] = 'k') then
                                       m := true;


                              if m <> true then
                                 begin
                                    writeln('This piece is gone! Please choose another');
                                    prompt_piece('W');
                                 end;

                              for i := 1 to 8 do
                                  for j := 1 to 6 do
                                      begin
                                           if chess_board[i, j] = 'k' then
                                              begin
                                                   x := i;
                                                   y := j;
                                              end;
                                     end;

                              king(x, y, c);

                              repeat
                                    writeln('Would you like to attack a piece or just move?');

                                    write('Enter ''a'' or ''m'': ');

                                    readln(am);
                                    if am <> 'a' then
                                       if am <> 'm' then
                                          writeln('Invalid Entry');

                              until (am = 'a') or (am = 'm');



                              case am of
                                    'a' : begin
                                             if attack = true then
                                                begin
                                                   for i :=  1 to 8 do
                                                      for j := 1 to 6 do
                                                         if attack_options[i,j] = 'T' then
                                                            if b = true then
                                                               if i+j = x+y then
                                                                  write('(',i,', ',j,')', ' ')
                                                               else
                                                                  if i-j = x-y then
                                                                      write('(',i,', ',j,')', ' ')
                                                            else
                                                                write('(',i,', ',j,')', ' ');


                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until attack_options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible attacks for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('W');
                                                end;
                                          end;


                                    'm' : begin
                                             if move = true then
                                                begin
                                                   for i := 1 to 8 do
                                                      for j := 1 to 6 do
                                                         if options[i,j] = 'T' then
                                                            write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible moves for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('W');
                                                end;
                                          end;

                              end;

                              {if (move <> true) and (attack <> true) then
                                    begin
                                       writeln('Sorry, you can''t do anything with this piece!');
                                       delay(3000);
                                       clrscr;
                                       prompt_piece('W');
                                    end; }
                           end;

                     'B' : begin
                              for i := 1 to 8 do
                                 for j := 1 to 6 do
                                    if (chess_board[i, j] = 'K') then
                                       m := true;


                              if m <> true then
                                 begin
                                    writeln('This piece is gone! Please choose another');
                                    prompt_piece('B');
                                 end;

                              for i := 1 to 8 do
                                  for j := 1 to 6 do
                                      begin
                                           if chess_board[i, j] = 'K' then
                                              begin
                                                   x := i;
                                                   y := j;
                                              end;
                                     end;

                              king(x, y, c);

                              repeat
                                    writeln('Would you like to attack a piece or just move?');
                                    write('Enter ''a'' or ''m'': ');
                                    readln(am);
                                    if am <> 'a' then
                                       if am <> 'm' then
                                          writeln('Invalid Entry');

                              until (am = 'a') or (am = 'm');

                              case am of
                                    'a' : begin
                                             if attack = true then
                                                begin
                                                   for i :=  1 to 8 do
                                                      for j := 1 to 6 do
                                                         if attack_options[i,j] = 'T' then
                                                            if b = true then
                                                               if i+j = x+y then
                                                                  write('(',i,', ',j,')', ' ')
                                                               else
                                                                   if i-j = x-y then
                                                                      write('(',i,', ',j,')', ' ')
                                                            else
                                                                write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until attack_options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible attacks for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('B');
                                                end;
                                          end;


                                    'm' : begin
                                             if move = true then
                                                begin
                                                   for i := 1 to 8 do
                                                      for j := 1 to 6 do
                                                         if options[i,j] = 'T' then
                                                            write('(',i,', ',j,')', ' ');
                                                   writeln;
                                                   repeat
                                                      writeln('Choose an option');
                                                      write('ROW: ');
                                                      readln(x1);
                                                      write('COLUMN: ');
                                                      readln(y1);
                                                   until options[x1,y1] = 'T';
                                                   temp := ' ';
                                                   temp := chess_board[x, y];
                                                   chess_board[x, y] := ' ';
                                                   chess_board[x1, y1] := temp;
                                                end
                                             else
                                                begin
                                                   writeln('There are no possible moves for this piece');
                                                   delay(1000);
                                                   clrscr;
                                                   prompt_piece('B');
                                                end;
                                          end;
                              end;

                              {if (move <> true) and (attack <> true) then
                                    begin
                                       writeln('Sorry, you can''t do anything with this piece!');
                                       delay(3000);
                                       clrscr;
                                       prompt_piece('B');
                                    end; }

                           end;
                  end;
               end;

      end;
      check; //to check if any piece can attack the king
   end;

procedure home_screen; //this procedure is the home_screen that gets shown at the beginning of the program
                       //it is made so that it prints one letter at a time with a small delay in between
   type
      letter = array[1..26] of char;

   var
      i, j : integer;
      text : string; //this variable is used to store the text that is going to be displayed; it is needed in order to print the letters one at a time
      letters : letter;

   begin
      textcolor(2);
      for i := 1 to 5 do
         writeln;
      write(' ' :38, 'Chess');
      writeln;
      writeln;
      writeln;
      text := 'Welcome to chess!';
      write(' ' :33);
      for i := 1 to 17 do
         begin
            write(copy(text, i, 1)); //copy built-in to pascal and selects one character of the string at a time
            delay(200);
         end;
      writeln;
      writeln;
      write(' ' :11);
      text := 'In this game, the objective is to get the opponent in check';
      for i := 1 to 59 do
         begin
            write(copy(text, i, 1));
            delay(100);
         end;
      text := '(when the king can be attacked by an enemy piece) 2 times in a row';
      writeln;
      writeln;
      write(' ' :7);
      for i := 1 to 66 do
         begin
            write(copy(text, i, 1));
            delay(100);
         end;
      text := 'This game is like normal chess, but without a knight';
      //52
      writeln;
      writeln;
      writeln;
      write(' ' :14);
      for i := 1 to 52 do
         begin
            write(copy(text, i, 1));
            delay(100);
         end;
      writeln;
      writeln;
      writeln(' ' :30, 'Here are the rules:');
      writeln;
      writeln('1. At the beginning of every move, you will be prompted for what piece');
      writeln(' ' :3, 'you would like to move (enter the first letter of the piece)');
      writeln;
      writeln('2. Then it''ll ask for a coordinate of the piece(unless it is a queen or king).');
      writeln(' ' :3, 'Enter the row number and column number of the piece you would like to move');
      writeln;
      writeln('3. You will then be prompted to move a piece or to attack another piece.');
      writeln(' ' :3, 'CHOOSE WISELY, YOU CANNOT CHANGE AFTER YOU HAVE CHOSEN!');
      writeln;
      writeln('4. If it is a rook, bishop, queen, or king, then you will be given options');
      writeln(' ' :3, 'where you want to move or attack. Enter the coordinate.');
      writeln;
      writeln('5. After you enter the coordinate, the piece will move to the desired location.');

      text := 'Press enter to play!';
      writeln;
      writeln;
      writeln;
      write(' ' :31);
      for i := 1 to 20 do
         begin
            write(copy(text, i, 1));
            delay(100);
         end;
      //readln;
   end;

procedure game;
   begin
      assign_pieces; //this assigns the pieces to the board to begin the game
      n := 1; //n is a counter i use for the move number
      home_screen;
      readln;
      repeat
         trial := 'W'; //trial is the parameter by which I call the promp_piece procedure
         prompt_piece(trial);
         trial := 'B';
         prompt_piece(trial);
         n := n+1; //after both player make a move, the move counter increases by 1
      until n = 40;
      if n = 40 then //if the move number reaches 40, the game automatically ends in a draw
         game_end('D'); //the procedure ends the game and declares it as a draw
   end;




{Executable section}
begin
   game; //the game :)
   readln;
end.
