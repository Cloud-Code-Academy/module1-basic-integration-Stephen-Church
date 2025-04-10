@IsTest
public class JSONPlaceholderExerciseTest {
    
    @IsTest
    static void testGetPostById() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new JSONPlaceholderMock(200, JSONPlaceholderMock.getSampleGetResponse()));
        
        // Act
        String response = JSONPlaceholderExercise.getPostById(1);
        
        // Assert
        Assert.isNotNull(response, 'Response should not be null');
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        Assert.areEqual(1, responseMap.get('id'), 'Post ID should match the request');
        Assert.areEqual('Sample Post', responseMap.get('title'), 'Post title should match the mock response');
    }
    
    @IsTest
    static void testCreatePost() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new JSONPlaceholderMock(201, JSONPlaceholderMock.getSamplePostResponse()));
        
        // Act
        String response = JSONPlaceholderExercise.createPost('New Post', 'This is a new post', 1);
        
        // Assert
        Assert.isNotNull(response, 'Response should not be null');
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        Assert.areEqual(101, responseMap.get('id'), 'New post should have ID 101');
        Assert.areEqual('New Post', responseMap.get('title'), 'Post title should match the request');
    }
    
    @IsTest
    static void testUpdatePost() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new JSONPlaceholderMock(200, JSONPlaceholderMock.getSamplePutResponse()));
        
        // Act
        String response = JSONPlaceholderExercise.updatePost(1, 'Updated Post', 'This is an updated post', 1);
        
        // Assert
        Assert.isNotNull(response, 'Response should not be null');
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        Assert.areEqual('Updated Post', responseMap.get('title'), 'Post title should be updated');
    }
    
    @IsTest
    static void testPatchPostTitle() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new JSONPlaceholderMock(200, JSONPlaceholderMock.getSamplePatchResponse()));
        
        // Act
        String response = JSONPlaceholderExercise.patchPostTitle(1, 'Updated Title');
        
        // Assert
        Assert.isNotNull(response, 'Response should not be null');
        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(response);
        Assert.areEqual('Updated Title', responseMap.get('title'), 'Post title should be updated');
    }
    
    @IsTest
    static void testDeletePost() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new JSONPlaceholderMock(200, ''));
        
        // Act
        Integer statusCode = JSONPlaceholderExercise.deletePost(1);
        
        // Assert
        Assert.areEqual(200, statusCode, 'Delete request should return status code 200');
    }

    @isTest
    static void generateHttpRequest_noBody() {

        String valueAfterBaseUrl = '/test';
        String method = 'GET';

        Test.startTest();
        HttpRequest returnedRequest = JSONPlaceholderExercise.generateHttpRequest(valueAfterBaseUrl, method, null);
        Test.stopTest();

        String expectedUrl = JSONPlaceholderExercise.BASE_URL + valueAfterBaseURL;
        Assert.areEqual(expectedUrl, returnedRequest.getEndpoint(), 'The endpoint was not set as expected.');
        Assert.areEqual('GET', returnedRequest.getMethod(), 'The method was not set as expected.');
        Assert.isTrue(String.isEmpty(returnedRequest.getBody()), 'The Body of the request should be null.');
    }

    @isTest
    static void generateHttpRequest_withBody() {

        String valueAfterBaseUrl = '/test';
        String method = 'GET';
        JSONPlaceholderExercise.Post testPost = new JSONPlaceholderExercise.Post('Title', 'Body', 1, 2);
        testPost.serializePostAsJson();

        Test.startTest();
        HttpRequest returnedRequest = JSONPlaceholderExercise.generateHttpRequest(valueAfterBaseUrl, method, testPost);
        Test.stopTest();

        String expectedUrl = JSONPlaceholderExercise.BASE_URL + valueAfterBaseURL;
        Assert.areEqual(expectedUrl, returnedRequest.getEndpoint(), 'The endpoint was not set as expected.');
        Assert.areEqual('GET', returnedRequest.getMethod(), 'The method was not set as expected.');
        Assert.isFalse(String.isEmpty(returnedRequest.getBody()), 'The Body of the request should be populated.');
    }

    @isTest
    static void sendHttpRequest_exception() {

        Boolean exceptionCaught = false;
        Test.setMock(HttpCalloutMock.class, new JSONPlaceholderMock.JsonPlaceholderMockFailed());

        Test.startTest();
        try {
            JSONPlaceholderExercise.sendHttpRequest(new HttpRequest());
        } catch (CalloutException e) {
            exceptionCaught = true;
        }
        Test.stopTest();

        Assert.isTrue(exceptionCaught, 'A Callout Exception should have been caught.');
    }
} 