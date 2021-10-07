# landlearn

import your .srt file (subtitle) to this app and know the word in file
you check the word that you know and you can learn other word

later you add another file, can see how many percentage of word know and how many not know


can import content by other way .srt file is a goal for now



## The Concept
first page has tab view
with to tab ( word and content )
word: on word can edit them and show status of them ( count of work - percent of knowing )
content: show the list of content ( show knowlabe percent over each content card ) - add and delete - if click on each then go to study page 

study( is for content): like tab view one side for the text and another side for status of words
almost like word section on first page

train area: this accesable from word section
and this is for train over words ( by different mode - train all - review knowlage - search over unknow word )

next plan:
a way to learning - learn word by more usablity ( common use )
and with any level few text to read and underestand have much word know




## the step of project

first: word section
---
a section for anything that need to work on words

secend: content section
---
adding a text and doing process on

the process is:

analyze words and add to dictionary
analyze content word and show status of content awarness



## what is needed?
* [ ] s


## data structure


#### words

id
word
translate
know

#### contents
id
title
body




## resource


Disctionary App
https://github.com/lohanidamodar/fl_dictio



https://github.com/snj07/flutter_show_more_text_popup	
https://prafullkumar77.medium.com/how-to-set-read-more-less-in-flutter-d601cf313a33


splite by word
(?:(?<![a-zA-Z])'|'(?![a-zA-Z])|[^a-zA-Z'])+


unicode version
'?[^\\p{L}']+'?


text editor 
https://levelup.gitconnected.com/flutter-medium-like-text-editor-b41157f50f0e

https://github.com/singerdmx/flutter-quill

https://flutterawesome.com/tag/editor/




## TODO
* [ ] import .srt convert to content
* [x] analyze content and export words
* [ ] show awareness of content
* [ ] show knowed word on study page
* [ ] 
