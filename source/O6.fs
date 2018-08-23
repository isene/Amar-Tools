\ This is the Forth version of the Open Ended D6 rolls used in the Amar RPG
\ See http://d6gaming.org for details about the Amar Role-Playing Game system

variable seed
utime drop seed !
: rnd ( n -- random[1-n] )
	seed @
    dup 13 lshift xor
    dup 17 rshift xor
    dup 5 lshift xor 
	dup seed ! 
	swap mod ;
: d6 6 rnd 1+ ; ( -- D6 )

variable d variable t variable m variable cf
: o6 ( -- O6 & "critical"/"fumble" )
	d6 d !
	true m !
	1 d @ = if
		begin 4 d6 dup t ! > while 
			d @ 1- d !
			1 t @ = m @ and if true cf ! then
			1 t @ = if true m ! else false m ! then
		repeat
	then
	6 d @ = if
		begin 3 d6 dup t ! < while 
			d @ 1+ d !
			6 t @ = m @ and if true cf ! then
			6 t @ = if true m ! else false m ! then
		repeat
	then
	d ?
	1 d @ > cf @ and if s" fumble" type then
	6 d @ < cf @ and if s" critical" type then
	cr
;

o6
