" Vim syntax file
" Language:	Amar Tools NPC
" Maintainer:	Geir Isene
" Last change:	2018-08-21
" Filenames:	*.npc
" URL:		https://isene.org/
"
" Copy this file into your vim/syntax folder
" to have nice highlighting of all *.npc, add this to your vimrc:
" autocmd BufRead,BufNewFile *.npc :set ft=npc

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax	keyword	npcATTR2    DB BP MD
syntax	match	npcSlash    "/"
syntax	match	npcSkills   "\(Name:\)\@!\u.\{-}\(:\|=\)\@="
syntax	match	npcWPN	    "\(Name:\)\@!\(^\s\{,2}\u\|>\)..\{-}  "
syntax	match	npcUNline   "\(^Day:.*\|^Night:.*\|^Type:.*\|^Area:.*\|^Description:.*\|^ENC:.*\|^Status:.*\|^Cult:.*\)" contains=npcDate
syntax	match	npcATTR1    "\u\{4,}:\@="
syntax	match	npcHEAD	    "^WEAPON .*"
syntax	match	npcHLine    ">*#\{4,}<*"
syntax	match	npcLine	    "-\{4,}"
syntax	match	npcNumber   "\d\d\{-}"
syntax	match	npcBy	    "By Amar Tools"
syntax	match	npcDate	    "Created: .*"
syntax	match	npcNAME	    "Name:\zs.*\|,\zs .*)"
syntax	match	encATTR	    "\u\{3}=\@=" 
syntax	match	encSpells   ".*# of spells.*" contains=npcNumber
syntax	keyword encSkill    Skill

" Define the default highlighting.

hi def link	npcHLine    Comment
hi def link	npcLine	    Comment
hi def link	npcBy	    Identifier
hi def link	npcDate	    Comment
hi def link	npcNAME	    Character
hi def link	npcATTR1    Type
hi def link	npcATTR2    Type
hi def link	npcSkills   Statement
hi def link 	npcSlash    Statement
hi def link 	npcWPN	    Statement
hi         	npcNumber   gui=bold term=bold cterm=bold
hi def link 	npcHEAD	    Comment
hi def link 	encATTR	    Type
  
let b:current_syntax = "npc"

" vim: ts=8
