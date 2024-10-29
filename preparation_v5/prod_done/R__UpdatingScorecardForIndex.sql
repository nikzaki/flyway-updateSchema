update gs_scorecard  set
                         which_nine = (select which_nine from gs_game_course gc WHERE gc.id = gs_scorecard.fk_game_course),
                         course_hole_no = (select hole_no FROM gs_course_hole ch WHERE ch.id = gs_scorecard.fk_course_hole)
WHERE which_nine is null;

update gs_scorecard set game_hole_no = course_hole_no + (gs_scorecard.which_nine -1 ) * 9
WHERE gs_scorecard.game_hole_no is null;