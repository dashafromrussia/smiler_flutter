package com.example.smiler_flutter;

import io.flutter.embedding.android.FlutterActivity;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;



public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.smiler";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        System.out.println("ONCREATE ONCREATE ONCREATE");
    }






    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        System.out.println("ONcccccccccccccccc");
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getUrl")) {
                                System.out.println("javaaaa");
                                Intent intent = new Intent(Intent.ACTION_SEND);
                                intent.setType("text/plain");
                                System.out.println(call.arguments+"arggggggggggggg");
                                intent.putExtra(Intent.EXTRA_TEXT,call.arguments.toString());
                                Intent choosen = Intent.createChooser(intent,"chose app");
                                startActivity(choosen);
// int batteryLevel = this.getBatteryLevel();
// List<Integer> results = new ArrayList<>();
//results.add(123);
                                result.success(1);
                            }
                        }
                );
    }

}