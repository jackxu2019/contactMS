# ContactMS
Interview project for iOS Engineer of Microsoft
### Projoect Description：

Read informations of contacts and present them 。
Key points：
1. The scrolling of avatar list and information table shoud have snap function.
2. The scrolling of avatar list and information table should be synchronized.
3. When the information table scrolling , avatar list should show a shadow line at bottom.
### Project Directory：

- common : Some classes designed for common use not only this project.
- model : Data model
- business : Besiness logics in this project（ contacts fetch，avatar image loading and processing etc. ）
- ui : Controls in this project.
- assets : Localization strings file，json data，avatar images，other images etc.
### Engagement：

- About string : All constant strings in coding must be used as STR( @"XXX" ) ,STR( ) is a self defined macros of NSLocalizedStringFromTable and defined in assets / localize.strings 。
- All methods have _mustInvoke_in_XXX or _mustInvoke_BeforeXXX  prefix，must be invoked  .
## 

### Some Key Classes:

#### ● ScrollSnapHelper
ScrollSnapHelper can let any scroll view have snap function easily.
- Make any UIScrollView snap to integer multiple of step length.
- Meke two scroll views scroll synchronized with proportional rapid ratio.

Using of it is quite simple：
```obj-c
ScrollSnapHelper* helper = [ ScrollSnapHelper new ];
[ helper attachScrollView: scrollV ]; //attach to a scroll view
helper.snapUnitLengthForOffset = 55; //the step length is 55，snap occured at integer multiple of 55.
```
Note : methods like `_mustInvoke_in_scrollViewXXX` must invoked in scroll view, for example：
> `_mustInvoke_in_scrollViewWillEndDraggingWithVelocity` must invoked in scrollViewWillEndDraggingWithVelocity
#####  ⚠️In later version，can let user just import header file by AOP design ( swizzle with runtime ).
`.scrollDirection` can be setted as horizontal or vertical scrolling snap，`.snapTolerance` can be setted as snap tolerance。
Synchronize two scrollViews：
```obj-c
[ helper1 bindScrollWithAnotherHelper:helper2 scrollRatioToOther:ratio isDual:YES ]
// isDual means dual binding ，ratio is the rapid proportion.
```

## 

#### ● HorizontalLineCellsView 和 HorizontalLineCircularImageCellsView
These two classes designed for common use ,not just this project,both of them have snap function.
- A convenient calss for row collectionView,no need dataSource and delegate.Can be presented just by setting cells number. 
- Snap function: can snapped to the center of cell automatically.


HorizontalLineCircularImageCellsView extends HorizontalLineCellsView，provide circular cell style.
- Every cell is imageView，can be setted as circular shape. ( not efficient )
- Every cell has a decorate view over it which can be used for present some effect like selected state（ defualt is a ring ）
##

#### ● BusinessEngine 
BusinessEngine is a sigleton class for all the logic business in this project, may have many sub parts in it。

For now, a sub part Contact in it is responsible for all logic of Contact 。

The use is quite simple：
```obj-c
[defualtBusinessEngine.contact loadAllContactsAsync]; //Loading all contact infos
// defaultBusinessEngine is a macros of [ BusinessEngine defaultEngine ] 
```
#####  Taking into efficiency and fluency，defualtBusinessEngine.contact.loadAllContactsAsync( ) designed as async
Notify occured by delegate in every state:
- The total count of contacts notified firstly. This can be used for pre rendering.
- Every contact information be fetched.
- Every avatar image is ready for use.



