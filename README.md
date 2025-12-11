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

### Today screen +  Badges and Levels

<div align="center">
  <img width="300" alt="Screenshot 2025-12-11 at 18 08 25" src="https://github.com/user-attachments/assets/e322c840-cc53-4244-9067-61eef5050644" />
  <img width="300" alt="Screenshot 2025-12-11 at 18 09 05" src="https://github.com/user-attachments/assets/4d4c65ea-89a1-4a6a-80a7-674b40630e32" />
</div>

### Tasks screen +  Tasks add/edit  

<div align="center">
    <img width="300" alt="Screenshot 2025-12-11 at 18 09 24" src="https://github.com/user-attachments/assets/845679cb-71a0-4bea-a921-83004beb10ab" />
  <img width="300" alt="Screenshot 2025-12-11 at 18 09 57" src="https://github.com/user-attachments/assets/225ce209-81ef-4daa-bb7a-3d41dd719aa1" />
  <img width="300" alt="Screenshot 2025-12-11 at 18 10 16" src="https://github.com/user-attachments/assets/b2942d4b-e803-4eed-ac35-40691239ee35" />
</div>

### Meme popup

<div align="center">
  <img width="300" alt="Screenshot 2025-12-11 at 18 10 44" src="https://github.com/user-attachments/assets/ef9ab962-36f6-492b-8bb3-db8320e6f9f5" />
  <img width="300" alt="Screenshot 2025-12-11 at 18 11 07" src="https://github.com/user-attachments/assets/604665b0-f3ee-4163-a7f4-07154915784d" />
</div>

### History

<div align="center">
  <img width="300" alt="Screenshot 2025-12-11 at 18 11 49" src="https://github.com/user-attachments/assets/f319bf66-6692-47d3-bcea-5da6fa9d5051" />
  <img width="300" alt="IMG_4172" src="https://github.com/user-attachments/assets/5076de90-b0e4-4d73-b5ae-e2b970bd82ad" />
</div>

<div align="center">
  <img width="300" alt="IMG_4171" src="https://github.com/user-attachments/assets/2e9646e0-95a2-408a-9b84-929251910271" />
  <img width="300" alt="IMG_4174" src="https://github.com/user-attachments/assets/c03004f5-c8cf-439e-a92d-1c6d6d0860b0" />
</div>

<div align="center">
  <img width="300" alt="IMG_4173" src="https://github.com/user-attachments/assets/4df923c7-3d8c-4c2e-a709-c18e407ada5f" />
</div>

### Category + Category add/edit

<div align="center">
  <img width="300" alt="IMG_4179" src="https://github.com/user-attachments/assets/f82cf747-8cfa-4b97-9de1-ed5e4617b4ee" />
  <img width="300" alt="IMG_4177" src="https://github.com/user-attachments/assets/64cc5add-b388-4f6c-9e1e-d0ab4a367125" />
  <img width="300" alt="IMG_4176" src="https://github.com/user-attachments/assets/de68d012-613b-45bd-9ed4-104226c3d8ec" />
</div>

### Settings 

<div align="center">
  <img width="300" alt="IMG_4175" src="https://github.com/user-attachments/assets/259acb99-dcf3-44a2-a525-211ac5fbe8b3" />
</div>

## Future work
- I'd definitely want to improve the meme reward to include gifs as well as selectors if users want nsfw (its currently disabled and the app will retry the call if such a meme appears)
- Analytics and streaks for each task / daily
- Sync the data either to ICloud or to a dedicated server
- Intoduce notifications and reminders
- Experiement with the apple watch  
