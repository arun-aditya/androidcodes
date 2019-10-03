package com.example.loginpage;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;

public class MainActivity extends AppCompatActivity
{
    private EditText name;
    private EditText pass;
    private Button login;
    private TextView info;
    private TextView signup;
    private TextView forgot;
    private  int counter=5;
    private FirebaseAuth firebaseaut;
    private ProgressDialog progress;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        name = findViewById(R.id.userName);
        pass = findViewById(R.id.passWord);
        login = findViewById(R.id.btnL);
        info = findViewById(R.id.inCorrect);
        signup= findViewById(R.id.signUp);

        info.setText("no.of attempts remaining: 5");
        firebaseaut=FirebaseAuth.getInstance();
        progress= new ProgressDialog(this);



        login.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View view)
            {

                check( name.getText().toString().trim(), pass.getText().toString().trim());
            }
        });

        signup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(MainActivity.this, Main2Activity.class);
                startActivity(intent);
            }
        });

        forgot= (TextView) findViewById(R.id.forgotPassword);
        forgot.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(MainActivity.this, passwordactivity.class));
            }
        });

    }

    private void check(String username, String password)
    {
        progress.show();
        firebaseaut.signInWithEmailAndPassword(username,password).addOnCompleteListener(    new OnCompleteListener<AuthResult>() {
            @Override
            public void onComplete(@NonNull Task<AuthResult> task) {
                if(task.isSuccessful()){
                    progress.dismiss();
                    if(emailverification()){
                        finish();
                        Toast.makeText(MainActivity.this, "Login Successful", Toast.LENGTH_SHORT).show();
                        startActivity(new Intent(MainActivity.this,secondactivity.class));
                    }
                    else{
                        Toast.makeText(MainActivity.this, "verify email", Toast.LENGTH_SHORT).show();
                        firebaseaut.signOut();
                    }

                }
                else{
                    progress.dismiss();
                    Toast.makeText(MainActivity.this, "Login Unsuccessful", Toast.LENGTH_SHORT).show();
                    counter--;
                    info.setText("no. of attempts remaining " +counter);
                    if(counter==0){
                        login.setEnabled(false);
                    }
                }
            }
        });


    }
    private boolean emailverification(){
        FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();
        boolean emailflag = user.isEmailVerified();
        return emailflag;
    }

}
