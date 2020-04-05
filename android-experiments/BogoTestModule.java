package com.facebook.react.uiapp;

import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.JavaOnlyArray;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.modules.storage.AsyncStorageModule;


import java.util.ArrayList;

import javax.annotation.Nonnull;

class BogoTestModule extends ReactContextBaseJavaModule {

  private AsyncStorageModule mStorage;
  String xx = "";
  private  JavaOnlyArray mSuperValue;

  public BogoTestModule(ReactApplicationContext context) {
    super(context);


    mStorage = new AsyncStorageModule(context);
    JavaOnlyArray keys = new JavaOnlyArray();
    keys.pushString("key1");
    Callback callback = new Callback() {
      @Override
      public void invoke(Object... args) {
        JavaOnlyArray mSuperValue = JavaOnlyArray.of(args);
        xx = mSuperValue.getArray(1).getArray(0).getString(1);
        Log.d("bogo-bogo","in the callback");
      }
    };
    mStorage.multiGet(keys,callback);
  }

  @Nonnull
  @Override
  public String getName() {
    return "BogoTest";
  }





  @ReactMethod (isBlockingSynchronousMethod = true)
  public String print() {
    //Log.d("bogo-bogo","printing bla bla bla");
    return xx;
  }

}
