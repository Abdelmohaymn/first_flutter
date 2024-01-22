
abstract class SocialChatStates {}

class SocialChatInitialState extends SocialChatStates {}

class SendMessageLoadingState extends SocialChatStates {}

class SendMessageSuccessState extends SocialChatStates {}

class SendMessageErrorState extends SocialChatStates {}

class GetMessagesSuccessState extends SocialChatStates{}

class ChatPickImageSuccessState extends SocialChatStates{}

class ChatPickImageErrorState extends SocialChatStates{}