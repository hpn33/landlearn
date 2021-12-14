

## Feature
- [x] collect Contents ( text and word )
- [x] manage contents ( crud )
- [ ] word oriented
  - [x] note
  - [x] where use
  - [x] online translation
  - [ ] know level (???)
- [ ] rech editor ( show knowlage level - ... )
- [ ] backup and data usablility for others ( json - bit file (for less file size) )
- [ ] ( online ) content provider
  - [how make feed website](https://themeisle.com/blog/news-aggregator-websites-examples/)
  - https://feedly.com
  - https://blog.feedspot.com/video_game_rss_feeds/
  - https://feeder.co/discover/18-great-gaming-feeds
  - https://www.gameinformer.com/rss
- [x] online translation
  - [x] use [package for translation](https://pub.dev/packages/translator)
  - [x] store result
  - [x] open google translate ( https://translate.google.com/ ) in browser
- [ ] import ( txt - subtitle (.srt) - by hand)
- [ ] drag new content to app
  - [ ] https://pub.dev/packages/desktop_drop

## Goal
* [x] good for public and publish
* [ ] nextVER (0.3.0) -

## Ver 0.3.0
- [x] show mean below of word
- [x] toggle overlay panel
- [x] show select with under line in any mode
- [ ] diff mode for word view & content view ( home page ) and search bar -mostUse -lastuse 
- [ ] import .srt file
- [ ] 

## TODO
* [ ] import .srt convert to content
* [x] analyze content and export words
* [x] show awareness of content
* [x] show knowed word on study page

* [x] many thing broken - fix analyze
* [x] sync awarness on content view - when work know update on wordview
* [x] count of word ( on project )
* [x] count of word ( totaly )
* [x] refresh and save data after analyze
* [ ] search bar for word
- [ ] some word not in en alphaChar ( solution )
- [ ] different view for words ( categories - count )
- [x] different reading mode ( read only - edit - show knowage - tooltip )
- [x] show count of content
- [x] refresh content list view when add new content
- [x] colorize edit panel on editor study Page 
- [x] tab key for change modes
- [x] analyze after add content
- [x] refresh content list view when add new content
- [x] show knowage percent of all the content text
- [x] study page padding to text - space between scrollbar
- [x] contentHub remove content and contentNotifier after delete

## improvment
- [ ] issue: analyze time need be faster ( make problem for load default data )

## subject

- [x] easy adding content
- [x] show knowing work on text content ( word by word )
- [x] need some default story
- [x] study page good edit flow ( !!! ) (research plz )
- [x] edit flow - maybe remove analyze button
- [x] show word usage sample ( ref ) ( if exist )
- [ ] mobilize - mobile ui
- [x] نمایش نمونه های استفاده شده از کلمه در متن ( اگر موجود باشد )
- [ ] رنگ بندی های متفاوت برای کلمات با وضعیت فهم متفاوت
- [ ] نمایش کلمات جدید ( فقط در این محتوا وجود دارد )
- [ ] ترجمه کلمه
  - [x] نوشتن ترجمه مورد نظر
  - [x] وصل شدن به یه منبع انلاین برای ترجمه ( به زبان های مختلف )
  - [ ] پخش صدا کلمه
- [ ] studyPage: View modes must be more useful ( less mode - more usablity ) read view and tooltip view in same mode - on mode change lost the location ( less mode for solution )
- [x] delete option for content ( -_- )
- [x] more readable ( the focus is on the words and text almost ignored )

## publish
- [x] default content
  - [x] logic
  - [x] refresh
  - [x] add for first time
  - [x] setting option: add default content ( any that not exsit )
- [x] ui & ux
  - [x] show word count in each category
  - [x] show word count on each content
  - [x] word status in study page ( awarness - know - unknow)
  - [x] study page: content view mode's
- [x] editor word
- [x] add sql to release file or ~~good lib~~
- [x] good README


## editor
- [x] analyze after change text
- [x] panel to edit content
- [x] toggle section ( text and words)

## Study Page
- [x] modes
  - [x] edit
  - [x] views
    - read only
    - know
    - unknow
- [ ] ui/ux
  - [ ] underline guide
    - [ ] dot orange underline for almost know level
- [x] performance
- [x] key binding ( to change mode tab, digit1 normal, digit2 know )
- [ ] show mean on below of word
- [ ] select word
- [ ] 

## import content panel
- [ ] txt
- [ ] .srt
- [x] cliboard


## word oriented
- [ ] word overlay panel
  - [x] where use
  - [x] translate
  - [x] open on browser
  - [x] note
  - [x] know level
  - [x] refs
- [x] select word and show on text


## ui
- [ ] look good ( search - what can do? )
  - [ ] choose good color pallet
  - [ ] https://www.youtube.com/watch?v=HwdweCX5aMI&t=67s
  - [ ] sample animation https://www.youtube.com/watch?v=gaKvL88Zws0
  - [ ] flex_color_scheme: ^4.1.1
- sample https://www.glasswire.com/
- sample https://anilist.co


## gamification
- [x] know level of word count ( like anilist.co )
- [x] know level of content percent knowlage
- [ ] achivement


## check 
- [ ] https://pub.dev/packages/dart_code_metrics
