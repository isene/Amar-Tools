! This is the Fortran version of the Open Ended D6 rolls used in the Amar RPG
! See http://d6gaming.org for details about the Amar Role-Playing Game system

FUNCTION D(x)
INTEGER      :: x
REAL         :: u
call random_number(u)
D = INT(FLOOR(x*u)+1)
END FUNCTION D

PROGRAM O6
IMPLICIT NONE
REAL         :: D
INTEGER      :: t, o
LOGICAL      :: m
CHARACTER*8  :: mark

m = .TRUE.
mark = ""

o = D(6)
t = D(6)
IF (o == 1) THEN
    DO WHILE (t < 4)
        IF ((t == 1) .AND. (m .EQV. .FALSE.)) THEN
            m = .TRUE.
        ELSE IF ((t == 1) .AND. (m .EQV. .TRUE.)) THEN
            mark = "fumble"
        ELSE
            m = .FALSE.
        END IF
        o = o - 1
        t = D(6)
    END DO
ELSE IF (o == 6) THEN
    DO WHILE (t > 3)
        IF ((t == 6) .AND. (m .EQV. .FALSE.)) THEN
            m = .TRUE.
        ELSE IF ((t == 6) .AND. (m .EQV. .TRUE.)) THEN
            mark = "critical"
        ELSE
            m = .FALSE.
        END IF
        o = o + 1
        t = D(6)
    END DO
END IF

WRITE(*,"(I3,a,a)") o, " ", trim(mark)
END PROGRAM O6
