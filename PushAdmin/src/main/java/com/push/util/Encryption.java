package com.push.util;

import java.math.BigInteger;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.security.MessageDigest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import org.apache.commons.lang3.StringUtils;


public class Encryption {
 
	public static String sha256(String input) {
		String result = "";

		try {
			MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
			messageDigest.reset();
			messageDigest.update(input.getBytes("utf8"));
			result = (String.format("%064x",
					new BigInteger(1, messageDigest.digest()))).toUpperCase();
		} catch (Exception e) {
			// e.printStackTrace();
		}

		return result;
	}

	public static boolean isAvailableKey(String serviceNo, String requestKey) {

		if (requestKey == null || requestKey.equals(""))
			return false;

		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMddHH");
		Calendar calendar = Calendar.getInstance();
		String currentTime = simpleDateFormat.format(calendar.getTime());
		String currentKey = sha256(sha256(currentTime) + serviceNo);

		Date currentDate = new Date();
		try {
			currentDate = simpleDateFormat.parse(currentTime);

			long previousTime = currentDate.getTime() - (60 * 60);
			Date previousDate = new Date(previousTime);
			String previousKey = sha256(
					sha256(simpleDateFormat.format(previousDate)) + serviceNo);

			if (requestKey.equals(currentKey)
					|| requestKey.equals(previousKey)) {
				currentDate = null;
				simpleDateFormat = null;
				currentKey = null;
				previousDate = null;
				return true;
			} else {
				currentDate = null;
				simpleDateFormat = null;
				currentKey = null;
				previousDate = null;
				return false;
			}
		} catch (ParseException pe) {
			currentDate = null;
			simpleDateFormat = null;
			// pe.printStackTrace();
		}
		return false;
	}

	public static String remakeMac(String mac, boolean isColon) {
		String noColonMac = (mac.replace(":", "")).toUpperCase();
		if (isColon == false)
			return noColonMac;

		String[] splitStr = noColonMac.split("(?<=\\G.{" + 2 + "})");
		String colonMac = StringUtils.join(splitStr, ":");

		return colonMac;
	}

	public static boolean availablePort(String host, int port) {
		boolean result = false;
		int timeout = 2000;
		SocketAddress socketAddress = new InetSocketAddress(host, port);
		Socket socket = new Socket();
		try {
			socket.setSoTimeout(timeout);
			socket.connect(socketAddress, timeout);
			result = true;
		} catch (Exception e) {
			result = false;
		} finally {
			try {
				socket.close();
				socket = null;
			} catch (Exception e) {
			}
		}

		return result;
	}
}
