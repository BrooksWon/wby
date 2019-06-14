package cn.isif.videodemo;

import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;
import android.widget.VideoView;

import java.util.Random;


public class VideoFragment extends Fragment {
    private VideoView vv_videoview;

    private final String[] url = {"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
            "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8",
            "http://alcdn.hls.xiaoka.tv/2017427/14b/7b3/Jzq08Sl8BbyELNTo/index.m3u8",
            "https://media.w3.org/2010/05/sintel/trailer.mp4",
            "http://www.w3school.com.cn/example/html5/mov_bbb.mp4",
            "https://www.w3schools.com/html/movie.mp4",
            "https://gcs-vimeo.akamaized.net/exp=1560522335~acl=%2A%2F623685558.mp4%2A~hmac=04a25fd3f900568a94dc4f0179f2cb79f287096349179567475dfdb42a20dd4c/vimeo-prod-skyfire-std-us/01/2670/7/188350983/623685558.mp4",
            "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8",
            "http://vfx.mtime.cn/Video/2017/03/31/mp4/170331093811717750.mp4",
            "http://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4"};


    public VideoFragment() {
        // Required empty public constructor
    }


    public static VideoFragment newInstance(String param1, String param2) {
        VideoFragment fragment = new VideoFragment();
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view =  inflater.inflate(R.layout.fragment_video, container, false);
        vv_videoview = view.findViewById(R.id.vv_videoview);

        //取消控制栏
//        vv_videoview.setMediaController(new MediaController(getContext()));
        int urlIndex = new Random().nextInt(10);

        vv_videoview.setVideoURI(Uri.parse(url[urlIndex]));
        vv_videoview.start();

        vv_videoview.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mp) {
                Toast.makeText(getContext(), "播放完成了", Toast.LENGTH_SHORT).show();
            }
        });
        return  view;
    }
}
