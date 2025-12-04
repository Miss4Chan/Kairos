# KAIROS

This project is part of my master studies and it's my individual project for the course Development for Mobile Devices.

A tiny, gamified task tracker built with **SwiftUI** + **SwiftData**.  

Complete tasks, earn XP, level up, and keep your streak of completed moments in History with a wholesome meme reward after each swipe for completion.

***Kairos = the right moment***

## Main functionalities

### Core 
- Create tasks that contain:
    - Title
    - Recurrence pattern (Daily, Weekly, Biweekly, Monthly, Bimonthly, or None)
    - Difficulty (controls the XP rewards)
    - Optional category
    - Optional due date and/or specific time

### Today
- Today shows only the pending tasks for the current period
- Swiping a task to the right completes it

### Scheduling and occurences
- Each task upon completition is stores as a TaskOccurence
- The Occurences store a snapshot of the task fields for that given moment (keeps history clean even when tasks change)

### XP + Leveling 
- Each completition of a task gives XP that corresponds to the difficulty level chosen for that task
- The total XP is stored in the user profile
- The level and the progress is shown in a progress bar
- There is a dedicated Badges and Levels screen where the current Level, Total XP, and current Badge are shown

### Categories 
- There are 3 default categories that are seeded on first launch
- Add/Edit categories can be found in the Settings page
- They have a name, color (hex), SF symbol (some are suggested, but user can manually enter name), preview for the SF Symbol icon
- Safe delete: in case a category gets deleted all tasks under it get safely reassigned to category: none

### History + Undo
- History shows and groups the TaskOccurences by day 
- Search by title
- Filter by category
- Swipe action can undo a task

### Settings
- Theme selector - light, dark, or match system
- Manage the categories list and create/edit them

### Meme reward
- After completing a task, if internet is available get served a wholesome meme from a wholesome meme endpoint
- If offline it shows one of 3 memes that are in the assets
- The meme is shown in a pop up sheet and it includes the original title and the image

### Tech stack 
-  Swift UI
-  SwiftData

## Demo screens
> TODO add the screenshots for all screens
### Today screen
### Badges and Levels
### Tasks screen
### Tasks add/edit  
### Meme popup
### History
### Category
### Category add/edit
### Settings 


## Future work
- I'd definitely want to improve the meme reward to include gifs as well as selectors if users want nsfw (its currently disabled and the app will retry the call if such a meme appears)
- Analytics and streaks for each task / daily
- Sync the data either to ICloud or to a dedicated server
- Intoduce notifications and reminders
- Experiement with the apple watch  
