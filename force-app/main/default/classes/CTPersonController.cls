/**
 * CTPersonController
 * Main controller class for Person__c object
 * @author Fernando Silva
 */
 public with sharing class CTPersonController {

    /**
     * generate unique token using mobile number generator
     * use MD5 algprithm to generate one-way hash
     * @param mobile
     * @return string token
     */
    public static String getToken(String MobileNo){
        Blob value = Blob.valueOf(MobileNo);
        Blob hash = Crypto.generateDigest('MD5', value);

        //get the string value of hash Blob
        return EncodingUtil.base64Encode(hash);
    }

    /**
     * get 100 contacts with recent health status change
     * @return List<Person__c>
     */
    public static List<Person__c> getRecentHealthChanges(){
        return [
            SELECT Id, Name, Health_Status__c, Mobile__c, Token__c, Status_Update_Date__c 
            FROM Person__c 
            ORDER BY Status_Update_Date__c 
            DESC 
            NULLS LAST 
            LIMIT 100
            ];
    }

    public static List<Person__c> searchPeople(String searchTerm){
        searchTerm = searchTerm + '%';
        return [
            SELECT Id, Name, Health_Status__c, Mobile__c, Token__c, Status_Update_Date__c 
            FROM Person__c 
            WHERE Name LIKE :searchTerm 
                OR Mobile__c LIKE :searchTerm 
                OR Token__c LIKE :searchTerm 
            ORDER BY Status_Update_Date__c 
            DESC 
            NULLS LAST
        ];
    }

    public static Person getPersonById(String personId){
        List<Person__c> people = [
            SELECT Id, Name, Health_Status__c, Mobile__c, Token__c, Status_Update_Date__c
            FROM Person__c
            WHERE Id = :personId
        ];
        if(people !=null && people.size() > 0){
            return people[0];
        }
        return null;
    }
}
