package cn.isif.videodemo;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class MainActivity extends AppCompatActivity {

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

    }

    public void loadVideo1(View view){
        startActivity(new Intent(this,VideoOnlyActivity.class));
    }
    public void loadVideo2(View view){
        startActivity(new Intent(this,ViedeoTwoActivity.class));
    }
    public void loadVideo4(View view){
        startActivity(new Intent(this,VideoFourActivity.class));
    }
    public void loadVideo9(View view){
        startActivity(new Intent(this,VideoNineActivity.class));
    }
}
