package cn.isif.bridge.bridge.utils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.ArrayList;
import java.util.Arrays;

/**
 * Gson解析帮助类
 * <pre>
 *     @Expose//序列化
 *     @SerializedName("name")//序列化名字
 * </pre>
 */
public class GsonUtil {
    private static Gson gson;

    private static Gson get() {
        if (gson == null) {
            GsonBuilder gsonBuilder = new GsonBuilder();
            gsonBuilder.serializeNulls();
//            gsonBuilder.setFieldNamingPolicy(LOWER_CASE_WITH_UNDERSCORES);
//            gsonBuilder.excludeFieldsWithoutExposeAnnotation();// 只转换有 @Expose 注解的字段
            gson = gsonBuilder.create();
//            gson = new Gson();
        }
        return gson;
    }

    public static String toJson(Object object) {
        return get().toJson(object);
    }

    public static <T> T fromJsonToModel(String jsonString, Class<T> tClass) {
        return get().fromJson(jsonString, tClass);
    }

    public static <T> ArrayList<T> fromJsonToModelList(String jsonString, Class<T[]> tClass) {
        T t[] = get().fromJson(jsonString, tClass);
        ArrayList<T> allTs = new ArrayList<T>(Arrays.asList(t));
        return allTs;
    }
}
