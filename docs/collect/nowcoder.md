# https://www.nowcoder.com/ta/huawei

## 1、字符串最后一个单词的长度 (简单) InputStream

```java
import java.util.Scanner;
import java.io.IOException;
import java.io.InputStream;

// 注意类名必须为 Main, 不要有任何 package xxx 信息
public class Main {
    public static void main(String[] args) throws IOException {
        InputStream in = System.in;
        int length = 0;
        char c;
        while ('\n' != (c = (char)in.read())) {
            length++;
            if (c == ' ') {
                length = 0;
            }
        }
        System.out.println(length);
    }
}
```

## 2、计算某字符出现次数 (简单) BufferedReader  + InputStreamReader

```java
import java.util.Scanner;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

// 注意类名必须为 Main, 不要有任何 package xxx 信息
public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        char[] chars1 = br.readLine().toLowerCase().toCharArray();
        char[] char2 = br.readLine().toLowerCase().toCharArray();
        int count = 0;
        for (int i=0; i<chars1.length; i++) {
            if ((chars1[i] >= 65 || chars1[i] < 90) && (chars1[i] == char2[0])) {
                count++;
            }
        }
        System.out.println(count);
    }
}
```

## 3、明明的随机数 (较难) BufferedReader  + InputStreamReader + StringBuilder

```java
import java.util.Scanner;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.IOException;

// 注意类名必须为 Main, 不要有任何 package xxx 信息
public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String str;
        while ((str = br.readLine()) != null) {
            boolean[] stu = new boolean[1001]; //空间为1000的话最大数据地址为999   而i的最大值是1000  会产生数组越界
            StringBuilder sb = new StringBuilder();
            int n = Integer.parseInt(str);
            for (int i=0; i<n; i++) {
                stu[Integer.parseInt(br.readLine())] = true;
            }
            for (int i=0; i<1001; i++) {
                if (stu[i]) {
                    sb.append(i).append("\n");
                }
            }
            sb.deleteCharAt(sb.length() - 1);
            System.out.println(sb.toString());
        }
    }
}
```

## 4、字符串分隔 （简单）BufferedReader  + InputStreamReader + str.substring + String.valueOf(tmp)

```java
import java.io.*;

public class Main{
    public static void main(String[] args) throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String str;
        while((str = br.readLine())!=null){
            int len = str.length();
            int start = 0;
            while (len >= 8){
                System.out.println(str.substring(start, start + 8));
                start += 8;
                len -= 8;
            }
            if (len > 0) {
                char[] tmp = new char[8];
                for(int i = 0;i<8;i++){
                    tmp[i]='0';
                }
                for(int i = 0; start < str.length(); i++) {
                    tmp[i] = str.charAt(start++);
                }
                System.out.println(String.valueOf(tmp));
            }
        }
    }
}
```

## 5、进制转换 （简单）Math.pow + Long.parseLong（）

```java
import java.util.*;
import java.io.*;

public class Main{
    public static void main(String[] args) throws IOException{
        BufferedReader bf = new BufferedReader(new InputStreamReader(System.in));
        String input;
        while((input = bf.readLine())!=null){
            String temp = input.substring(2,input.length());
            int sum = 0;
            int length = temp.length();
            for(int i= length-1;i>=0;i--){
                char c = temp.charAt(i);
                int tempNum = (int)c;
                if(tempNum>=65){
                    tempNum = tempNum - 65 + 10;
                }else{
                    tempNum = tempNum - 48;
                }
                sum = sum + (int) Math.pow(16, length-i-1)*tempNum;
            }
            System.out.println(sum);
        }
    }
}

```

```java
import java.io.*;
public class Main {
    public static void main(String[] args) throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String line = null;
        while((line = br.readLine()) != null){
            System.out.println(Long.parseLong(line.substring(2) , 16));
        }
    }
}
```

## 6、质数因子 （简单） Math.sqrt + StringBuilderStringBuilder

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Main {

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String str;
        while ((str = br.readLine()) != null) {
            int num = Integer.parseInt(str);
            StringBuilder sb = new StringBuilder();
            for (int i = 2; i <= Math.sqrt(num); i++) {
                if (num % i == 0) {
                    sb.append(i).append(" ");
                    num = num / i;
                    i--;
                }
            }
            sb.append(num).append(" ");
            System.out.println(sb.toString());
        }
    }
}
```

## 7、取近似值 （入门） InputStream read()

```java

import java.io.InputStream;
public class Main {
public static void main(String[] args) throws Exception {
        InputStream in = System.in;
        int c = (int) in.read();
        int ans=0;
        int temp=0;
        while(c != '\n'){
            if(temp==1){
                if((int) c>52){
                    ans+=1;
                }
                System.out.println(ans);
                break;
            }else if(temp==0){
                if(c=='.'){
                    temp=1;
                }else{
                    ans=ans*10+(int) (c-48);
                }
            }


            c = (char) in.read();
        }
        if(temp==0){
            System.out.println(ans);
        }
    }
}


```


## 8、合并表记录（简单）StreamTokenizer nextToken()

```java
import java.util.*;
import java.io.*;
public class Main {
    public static void main(String[] args) throws Exception{
         StreamTokenizer st = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        st.nextToken();      // 分隔符
        int n = (int) st.nval;   // 强转
        int[] arr = new int[n];
 
        for (int i = 0; i < n; i++) {
            st.nextToken();
            int key = (int) st.nval;
            st.nextToken();
            int value = (int) st.nval;
            arr[key] = arr[key] + value;
        }
 
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < arr.length ; i++) {
            if(arr[i] != 0){
                sb.append(i).append(" ").append(arr[i]).append("\n");
            }
        }
        System.out.println(sb.toString());
    }
}
```

## 9、提取不重复的整数 （入门） InputStream StringBuilder lastIndexOf()

```java
import java.io.InputStream;

public class Main {

    public static void main(String[] args) throws Exception {
        InputStream in = System.in;
        int available = in.available()-1;
        char[] chars = new char[available];
        while (available-- > 0) {
            chars[available] = (char) in.read();
        }
        StringBuilder resul = new StringBuilder();
        for (int i = 0; i < chars.length; i++) {
            if (resul.lastIndexOf(String.valueOf(chars[i])) != -1){
                continue;
            }
            resul.append(chars[i]);
        }
          System.out.println(resul.toString());
    }

}
```

## 10、字符个数统计 （入门） readLine() charAt() StringBuilder

```java
import java.util.*;
import java.io.*;
public class Main{
    public static void main(String[]args)throws Exception{
        BufferedReader shuru = new BufferedReader(new InputStreamReader(System.in));
        String s = shuru.readLine();
        int[] a = new int[128];
        int count=0;
        for(int i=0;i<s.length();i++){
            char b = s.charAt(i);
            if(a[b]==0){
                count++;
                a[b]=1;
            }
        }
        System.out.println(count);
    }
}
```