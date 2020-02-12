/*
 * Author: Cole Clements, cclements2016@my.fit.edu
 * Course: CSE 4250, Spring 2019
 * Project: Prok1, RSA Project
 * Implementation:
 * Kotlin Version
 */

import java.math.BigInteger
import java.util.Random
import java.util.Scanner

fun main(args : Array<String>) {
	val stdin = Scanner(System.`in`)
	
	val bitLen = (System.getProperty("bits")).toInt()		//Grab sys arg for bit length
	var rnd = Random((System.getProperty("seed").toLong())) //Grab sys arg for seed for random gen
	
	val q = BigInteger.probablePrime(bitLen, rnd) //create random primes for RSA
	val p = BigInteger.probablePrime(bitLen, rnd)
	val e = BigInteger.probablePrime(bitLen, rnd)
	
	val product = q.multiply(p) //values for RSA encryption/decryption
	val totient = q.subtract(BigInteger.ONE).multiply(p.subtract(BigInteger.ONE))
    val d = e.modInverse(totient)
	
	var message: BigInteger
	var cipher: BigInteger
	
	var input = "start"
    println("type q to quit");
    while (!input.equals("q")) {	//loop thorough input
    	input = stdin.next();
    		
        if (input.equals("message")) {
            message = BigInteger(stdin.next());
            cipher = message.modPow(e, product);
            println("cipher  " + cipher);
        } else if (input.equals("cipher")) {
        	cipher = BigInteger(stdin.next());
        	message = cipher.modPow(d, product);
        	println("message " + message);
        }
    }
}