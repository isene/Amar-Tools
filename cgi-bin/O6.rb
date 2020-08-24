#!/usr/bin/env ruby
#encoding: utf-8

# This is the simple frontend for O6 - generating 10 open ended d6 rolls
print "Content-type: text/html\n\n"
print <<HTML1
<html>
<head>
<title>Open ended D6 rolls</title>
<link rel="stylesheet" href="https://unpkg.com/purecss@2.0.3/build/pure-min.css" integrity="sha384-cg6SkqEOCV1NbJoCu11+bm0NvBRc8IYLRGXkmNrqUBfTjmMYwNKPWBTIKyw9mHNJ" crossorigin="anonymous">
<link rel="stylesheet" href="amar.css">
<meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body bgcolor="#FFFFFF" text="#000000">

<table width="600" border="0" cellspacing="0" cellpadding="2" align="center">
<tr><td><center><h1>Open ended D6 rolls (O6):</h1></td></tr>
HTML1

10.times {puts "<tr><td><center><h2>" + `./O6` + "</h2></center></td></tr>"}
  
print <<HTML2
  <tr>                                                                                                                                                       
    <td align="center">                                                                                                                                      
      <form name="new" method="post" action="/cgi-bin/O6.rb">                                                                                    
      <input type="submit" class="pure-button button-dice" name="new" value=" Make new rolls "></form>
      <p><button class="pure-button button-front" onclick="location.href = '/amar.html';" > Front page </button></p>
    </td>                                                                                                                                                    
  </tr>                                                                                                                                                      
	<tr><td><center><br /><image src="/images/dice.png" /></td></tr>
  <tr><td><center><br />See the <a href="http://d6gaming.org/index.php/The_Character#Open_Ended_Rolls">Amar RPG wiki</a> for details on what an open ended d6 roll is.</td></tr>
  <tr><td><center><small>This <a href="http://isene.org/x/O6.f95">program</a> is written in Fortran by Geir Isene.</small></center></td></tr>
</table>
</body>
</html>
HTML2
