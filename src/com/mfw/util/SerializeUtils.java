package com.mfw.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.mfw.entity.system.User;

import net.sf.json.JSONObject;
import redis.clients.jedis.Jedis;

public class SerializeUtils {
	
	private static Logger logger = LoggerFactory.getLogger(SerializeUtils.class);
	
	/**
	 * 反序列化
	 * @param bytes
	 * @return
	 */
	public static Object deserialize(byte[] bytes) {
		
		Object result = null;
		
		if (isEmpty(bytes)) {
			return null;
		}

		try {
			ByteArrayInputStream byteStream = new ByteArrayInputStream(bytes);
			try {
				ObjectInputStream objectInputStream = new ObjectInputStream(byteStream);
				try {
					result = objectInputStream.readObject();
				}
				catch (ClassNotFoundException ex) {
					throw new Exception("Failed to deserialize object type", ex);
				}
			}
			catch (Throwable ex) {
				throw new Exception("Failed to deserialize", ex);
			}
		} catch (Exception e) {
			logger.error("Failed to deserialize",e);
		}
		return result;
	}
	
	public static boolean isEmpty(byte[] data) {
		return (data == null || data.length == 0);
	}

	/**
	 * 序列化
	 * @param object
	 * @return
	 */
	public static byte[] serialize(Object object) {
		
		byte[] result = null;
		
		if (object == null) {
			return new byte[0];
		}
		try {
			ByteArrayOutputStream byteStream = new ByteArrayOutputStream(1024);
			try  {
				if (!(object instanceof Serializable)) {
					throw new IllegalArgumentException(SerializeUtils.class.getSimpleName() + " requires a Serializable payload " +
							"but received an object of type [" + object.getClass().getName() + "]");
				}
				ObjectOutputStream objectOutputStream = new ObjectOutputStream(byteStream);
				objectOutputStream.writeObject(object);
				objectOutputStream.flush();
				result =  byteStream.toByteArray();
			}
			catch (Throwable ex) {
				throw new Exception("Failed to serialize", ex);
			}
		} catch (Exception ex) {
			logger.error("Failed to serialize",ex);
		}
		return result;
	}
	
	
	 public static void main(String [] args){
	        Jedis jedis = new Jedis("127.0.0.1");
	        String keys = "name";
	        // 删数据
	        //jedis.del(keys);
	        // 存数据
	        jedis.set(keys, "zy");
	        // 取数据
	        String value = jedis.get(keys);
	        System.out.println(value);
	        
	        //存对象
	        User p=new User();  //User类记得实现序列化接口 Serializable
	        p.setNAME("姚波");
//	        JSONObject j = JSONObject.fromObject(p);
	        jedis.set("user".getBytes(), serialize(p));
	        byte[] byt=jedis.get("user".getBytes());
	        Object obj=deserialize(byt);
	        if(obj instanceof User){
	            System.out.println(obj);
	        }
	    }
}
