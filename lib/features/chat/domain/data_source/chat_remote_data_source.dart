abstract class ChatRemoteDataSource {
  Future<void> connect(String token);
  Future<void> subscribeToConversation(int conversationId);

  
  
}
