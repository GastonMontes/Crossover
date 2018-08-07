# Project Assessment

CrossChat is an iOS Chat Analyzer Bot application created by Crossover team. The Bot analyses the messages sent to it and responds with a JSON string containing results of its analysis, in addition to the original message with special keywords highlighted.

## Special contents that this Bot is supposed to look for:
You can consider the following points as requirements, so, please give them your attention!

1. &commat;mentions - A way to mention a user. Always starts with an '@' followed by at least a single word character and ends when hitting a non-word character.
2. &num;hashtags **(To be implemented)** - Metadata tags which allow users to apply dynamic, user-generated tagging. Always starts with a '#' followed by at a least single word character and ends when hitting a non-word character.
3. Emoticons - We only considers 'custom' emoticons which are alphanumeric strings, no longer than 15 characters, and contained in parentheses. Anything matching this criteria is an emoticon, for example, (smile), (cool), (megusta), (john), and (doe).
4. Links - Any URLs contained in the message.

## Examples

Sending the following messages to the Bot would result in the corresponding JSON strings being returned.

Input: "`#hello @chris are you around?`"

Returns (`JSON`):
```javascript
{
  "mentions": [
    "chris"
  ],
  "hashtags": [
    "hello"
  ]
}
```

Input: "`Good morning! (megusta) (coffee), please check this new landing: https://google.com/`"

Returns (`JSON`):
```javascript
{
  "emoticons": [
    "megusta",
    "coffee"
  ],
  "urls": [
    "https://google.com/"
  ]
}
```

## Notes
- The application should work properly in both Portrait and Landscape modes.
- The project is still under development, so, the #hashtags feature is not yet implemented and you will need to apply it during your task.
- The project is following the TDD approach.
- This Bot doesn't utilize any APIs, and it performs all of its magic locally.

## Tasks
1. Find bugs and fix them, please do not spend your valuable time on structure modifications, focus on fixing bugs.
2. Refactor ContentAnalyser and all of the Model classes.
3. Find and fix the memory leak inside ChatMessageController class.
4. Implement #hashtags feature including all necessary unit tests.

**PLEASE NOTE THAT ALL THE TASKS LISTED ABOVE ARE MANDATORY.**

## We'll be evaluating your submission from the following perspectives:
- Code quality and best practices
- Implementation of new feature
- Bug fixes
- Unit Tests

## Build System
You’ll need a Mac with Xcode v.9+, it’s the basic requirement for iOS development. Although the project includes a Podfile, it doesn't utilize any 3rd party libraries at the moment.

## Dependencies
- Xcode v.9+
- iOS SDK 10+
- iOS Simulator 7+

## How to deliver:

This is how we are going to access and evaluate your submission, so please make sure you go through the following steps before submitting your answer.

1. Make sure to run unit tests, automated UI tests, ensure there are no errors and all dependencies are correctly configured.
2. Zip your project folder and name it 'crosschat-ios-<YourNameHere>.zip'.
3. Store your archive in a shared location where Crossover team can access and download it for evaluation. Do not forget to paste the shared link in the answer field of this question.