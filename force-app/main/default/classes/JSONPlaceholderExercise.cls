public class JSONPlaceholderExercise {
    @TestVisible private static final String BASE_URL = 'https://jsonplaceholder.typicode.com';
    private static final String SLASH_POSTS = '/posts';
    private static final String SLASH = '/';
    private static final String ERROR_STRING = 'Error making callout.';

    public class Post {
        public String title;
        public String body;
        public Integer id;
        public Integer userId;
        public String serializedJson {get; set;}

        public Post (String title, String body, Integer userId, Integer id) {
            this.title = title;
            this.body = body;
            this.id = id;
            this.userId = userId;
        }

        public void serializePostAsJson() {
            serializedJson = JSON.serialize(this);
        }
    }
    
    public static HttpRequest generateHttpRequest(String valueAfterBaseUrl, String method, Post post) {

        HttpRequest request = new HttpRequest();
        request.setEndpoint(BASE_URL + valueAfterBaseUrl);
        request.setMethod(method);
        if (post != null) {
            post.serializePostAsJson();
            request.setBody(post.serializedJson);
        }
        return request;
    }

    public static HttpResponse sendHttpRequest(HttpRequest request) {

        Http http = new Http();
        HttpResponse response = new HttpResponse();
        try {
            response = http.send(request);
        } catch (CalloutException e) {
            throw new CalloutException(ERROR_STRING);
        }
        return response;
    }

    /**
     * Exercise 1: Implement a GET request to fetch a post by ID
     * Endpoint: /posts/{postId}
     * @param postId - The ID of the post to fetch
     * @return String - The JSON response from the API
     */
    public static String getPostById(Integer postId) {
        HttpRequest request = generateHttpRequest(SLASH_POSTS + SLASH + postId, 'GET', null);
        HttpResponse response = sendHttpRequest(request);
        return response.getBody();
    }
    
    /**
     * Exercise 2: Implement a POST request to create a new post
     * Endpoint: /posts
     * @param title - The title of the post
     * @param body - The body content of the post
     * @param userId - The user ID creating the post
     * @return String - The JSON response from the API
     */
    public static String createPost(String title, String body, Integer userId) {
        Post postToCreate = new Post(title, body, userId, null);
        HttpRequest request = generateHttpRequest(SLASH_POSTS, 'POST', postToCreate);
        HttpResponse response = sendHttpRequest(request);
        return response.getBody();
    }
    
    /**
     * Exercise 3: Implement a PUT request to update a post
     * Endpoint: /posts/{postId}
     * @param postId - The ID of the post to update
     * @param title - The new title
     * @param body - The new body content
     * @param userId - The user ID
     * @return String - The JSON response from the API
     */
    public static String updatePost(Integer postId, String title, String body, Integer userId) {
        Post postToUpdate = new Post(title, body, userId, postId);
        HttpRequest request = generateHttpRequest(SLASH_POSTS + SLASH + postId, 'PUT', postToUpdate);
        HttpResponse response = sendHttpRequest(request);
        return response.getBody();
    }
    
    /**
     * Exercise 4: Implement a PATCH request to partially update a post
     * Endpoint: /posts/{postId}
     * @param postId - The ID of the post to patch
     * @param title - The new title (can be null)
     * @return String - The JSON response from the API
     */
    public static String patchPostTitle(Integer postId, String title) {
        Post postToPatch = new Post(title, null, null, null);
        HttpRequest request = generateHttpRequest(SLASH_POSTS + SLASH + postId, 'PATCH', postToPatch);
        HttpResponse response = sendHttpRequest(request);
        return response.getBody();
    }
    
    /**
     * Exercise 5: Implement a DELETE request to remove a post
     * Endpoint: /posts/{postId}
     * @param postId - The ID of the post to delete
     * @return Integer - The HTTP status code from the response
     */
    public static Integer deletePost(Integer postId) {
        HttpRequest request = generateHttpRequest(SLASH_POSTS + SLASH + postId, 'DELETE', null);
        HttpResponse response = sendHttpRequest(request);
        return response.getStatusCode();
    }
} 