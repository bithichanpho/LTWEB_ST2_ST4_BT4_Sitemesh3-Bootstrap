package utils;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

import configs.AppConfig;
import jakarta.servlet.http.Part;

public class ImageStorageUtil {

	private ImageStorageUtil() {
	}

	private static volatile File webappImageDirCache;
	private static volatile boolean resolved = false;

	public static String store(Part part, String subFolder, String fileName) throws IOException {
		// 1) Luu vao thu muc external (persistent qua cac lan Clean/publish)
		String externalDirPath = AppConfig.EXTERNAL_UPLOAD_DIR + File.separator + subFolder;
		File externalDir = new File(externalDirPath);
		if (!externalDir.exists()) {
			externalDir.mkdirs();
		}

		Path externalTarget = Paths.get(externalDirPath, fileName);
		try (InputStream in = part.getInputStream()) {
			Files.copy(in, externalTarget, StandardCopyOption.REPLACE_EXISTING);
		}

		copyToWebappSource(externalTarget, subFolder, fileName);

		return subFolder + "/" + fileName;
	}

	private static void copyToWebappSource(Path savedFile, String subFolder, String fileName) {
		try {
			File webappImageDir = resolveWebappImageDir();
			if (webappImageDir == null) {
				System.err.println("[ImageStorageUtil] Khong tim thay src/main/webapp/image trong project "
						+ "(co the dang chay tu file build, khong phai workspace Eclipse) - bo qua buoc "
						+ "copy anh vao source, anh van hien thi binh thuong tu thu muc external.");
				return;
			}
			File targetDir = new File(webappImageDir, subFolder);
			if (!targetDir.exists()) {
				targetDir.mkdirs();
			}
			Files.copy(savedFile, new File(targetDir, fileName).toPath(), StandardCopyOption.REPLACE_EXISTING);
		} catch (Exception e) {
			// Khong duoc de loi o buoc "copy them de commit git" lam fail ca request upload
			System.err.println("[ImageStorageUtil] Khong the copy anh vao src/main/webapp/image: " + e.getMessage());
		}
	}

	private static File resolveWebappImageDir() {
		if (resolved) {
			return webappImageDirCache;
		}
		synchronized (ImageStorageUtil.class) {
			if (resolved) {
				return webappImageDirCache;
			}
			resolved = true;
			try {
				File start = new File(ImageStorageUtil.class.getProtectionDomain()
						.getCodeSource().getLocation().toURI());

				File dir = start.isFile() ? start.getParentFile() : start;
				int maxDepth = 12;
				while (dir != null && maxDepth-- > 0) {
					File candidate = new File(dir, "src" + File.separator + "main" + File.separator
							+ "webapp" + File.separator + "image");
					if (candidate.isDirectory()) {
						webappImageDirCache = candidate;
						return webappImageDirCache;
					}
					dir = dir.getParentFile();
				}
			} catch (URISyntaxException | SecurityException | NullPointerException e) {
				System.err.println("[ImageStorageUtil] Khong xac dinh duoc vi tri source cua project: "
						+ e.getMessage());
			}
			webappImageDirCache = null;
			return null;
		}
	}
}
