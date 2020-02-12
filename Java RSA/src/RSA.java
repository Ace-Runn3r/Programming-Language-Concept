/*
 * Author: Cole Clements, cclements2016@my.fit.edu
 * Course: CSE 4250, Spring 2019
 * Project: Proj1, RSA Project
 * Implementation: 
 * Java Version
 */

import java.math.BigInteger;
import java.util.Scanner;
import java.util.Random;

public class RSA{

	public static void main (String args[]){
    	final Scanner  stdin = new Scanner(System.in);

    	int bitLen = Integer.parseInt(System.getProperty("bits"));				//Grab sys arg for bit length
    	Random rnd = new Random(Long.parseLong(System.getProperty("seed")));	//Grab sys arg for seed for random gen
    	
    	
    	BigInteger p = BigInteger.probablePrime(bitLen, rnd);	//create random primes for RSA
    	BigInteger q = BigInteger.probablePrime(bitLen, rnd);
    	BigInteger e = BigInteger.probablePrime(bitLen, rnd);
    	
    	BigInteger product = q.multiply(p);		//values for RSA encryption/decryption
    	BigInteger totient = q.subtract(BigInteger.ONE).multiply(p.subtract(BigInteger.ONE));
    	BigInteger d = e.modInverse(totient);
    	
    	BigInteger message;
    	BigInteger cipher;
    	
    	String input = "start";
    	System.out.println("type q to quit");
    	while (!input.equals("q")) {			//loop thorough input
    		input = stdin.next();
    		
        	if (input.equals("message")) {
            	message = new BigInteger(stdin.next());
            	cipher = message.modPow(e, product);
            	System.out.println("cipher  " + cipher);
        	} else if (input.equals("cipher")) {
        	    cipher = new BigInteger(stdin.next());
        	    message = cipher.modPow(d, product);
        	    System.out.println("message " + message);
        	}
    	}
    	
    	stdin.close();
	}
}