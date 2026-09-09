package configs;

import java.io.File;

public class AppConfig {
	public static final String ROOT_UPLOAD_DIR = "/image";

	public static final String EXTERNAL_UPLOAD_DIR =
			System.getProperty("user.home") + File.separator + "baitap04-uploads";
}
