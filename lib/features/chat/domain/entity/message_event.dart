abstract class MessageEvent {}

class MessageSentEvent extends MessageEvent {}
class MessageDeletedEvent extends MessageEvent {}
class MessageSeenEvent extends MessageEvent {}
