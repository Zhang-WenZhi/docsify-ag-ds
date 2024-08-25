## https://www.nowcoder.com/ta/huawei

## 面试笔刷101: https://www.nowcoder.com/exam/oj

请参考帖子https://www.nowcoder.com/discuss/276处理循环输入的问题

## Java 处理多行输入 while ((line = reader.readLine()) != null && !line.isEmpty()) JDK 17

```java
import java.util.Scanner;

public class MultiLineInput {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("请输入多行文本，以空行结束：");

        String line;
        while ((line = scanner.nextLine()) != null && !line.isEmpty()) {
            System.out.println("你输入的行是：" + line);
        }

        scanner.close();
    }
}
```

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class MultiLineInput {
    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        System.out.println("请输入多行文本，以空行结束：");

        String line;
        try {
            while ((line = reader.readLine()) != null && !line.isEmpty()) {
                System.out.println("你输入的行是：" + line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                reader.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
```

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

## 11、数字颠倒（简单）


```java
import java.util.Scanner;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.BufferedReader;

// 注意类名必须为 Main, 不要有任何 package xxx 信息
public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder sb = new StringBuilder();
        sb.append(br.readLine().trim());
        System.out.println(sb.reverse());
    }
}
```

## 12、字符串反转（简单）同11

```java
import java.util.Scanner;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.BufferedReader;

// 注意类名必须为 Main, 不要有任何 package xxx 信息
public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String s = br.readLine();
        System.out.println(new StringBuilder(s).reverse().toString());
    }
}
```

## 13、句子逆序（简单）


```java
import java.util.Scanner;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.BufferedReader;

// 注意类名必须为 Main, 不要有任何 package xxx 信息
public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String[] s = br.readLine().split(" ");
        for (int i = s.length - 1; i >= 0; i--) {
            System.out.print(s[i] + " ");
        }
    }
}
```

## 14、字符串排序（简单）多行输入处理

```java
import java.util.Scanner;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.util.Arrays;

// 注意类名必须为 Main, 不要有任何 package xxx 信息
public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        int lineCount = Integer.parseInt(br.readLine());
        String[] result = new String[lineCount];
        for (int i=0;i<lineCount; i++) {
            result[i] = br.readLine();
        }
        StringBuilder sb = new StringBuilder();
        Arrays.sort(result);
        for (String w : result) {
            sb.append(w).append('\n');
        }
        System.out.println(sb.toString());
    }
}
```

## 15、求int型正整数在内存中存储时1的个数 (简单) InputStream 单独用，接收二进制数据

```java
import java.util.Scanner;
import java.io.InputStream;


// 注意类名必须为 Main, 不要有任何 package xxx 信息
public class Main {
    public static void main(String[] args) throws Exception {
        InputStream stream = System.in;
        int inCount;
        byte[] bytes = new byte[1024];
        while ((inCount = stream.read(bytes)) > 0) {
            String numStr = new String(bytes, 0, inCount-1);
            int num = Integer.parseInt(numStr);
            char[] numChars = Integer.toBinaryString(num).toCharArray();
            int numCount = 0;
            for (int i=0; i<numChars.length; i++) {
                if (numChars[i] == '1') {
                    numCount += 1;
                }
            }
            System.out.println(numCount);
        }
    }
}
```

## 16、购物单（中等）多行多列输入

```java
import java.io.*;
import java.util.*;
import java.lang.Math;
 
public class Main{
    public static void main(String[]args) throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String str= br.readLine();
//         while((str = br.readLine()) != null){
            String [] money_number = str.split(" ");
            int money = Integer.parseInt(money_number[0]);//钱数
            int count = Integer.parseInt(money_number[1]);//物品数
            int v[] = new int[count + 1];//物品的v p q和附件序号
            int p[] = new int[count + 1];
            int q[] = new int[count + 1];
            int sub1[] = new int[count + 1];
            int sub2[] = new int[count + 1];
            int dw = 100;
            boolean flag = true;
            for(int i = 1;i < count + 1;i++){//第i件物品的属性
                String obj[] = br.readLine().split(" ");
                v[i] = Integer.parseInt(obj[0]);
                if (flag && v[i] % dw  != 0) {
                    dw = 10;
                    flag = false;
                    for (int m = 1; m < i; m ++) {//出现不是整百的，按整十除
                        v[m] *=10;
                        p[m] *=10;
                    }
                }
                v[i] = v[i] / dw;
                p[i] = Integer.parseInt(obj[1]) * v[i];//价值=价格*权重，需要的是p最大
                q[i] = Integer.parseInt(obj[2]);
                if (q[i] > 0) {//是附件
                    if(sub1[q[i]] == 0)
                        sub1[q[i]] = i;//是附件1
                    else
                        sub2[q[i]] = i;//是附件2
                }
            }
            money /= dw;
            int dp[][] = new int[count +1][money + 1];//money为啥+1？
            for(int i = 1; i < count + 1; i++) {//两层for循环，动态规划二维表逐列逐行
                int p1 = 0, p2 = 0, p3 = 0;//根据附件数量，分4种情况v[i]、v1、v2、v3
                int v1 = -1, v2 = -1, v3 = -1;//
                if(sub1[i] != 0) {
                    v1 = v[i] + v[sub1[i]];
                    p1 = p[i] + p[sub1[i]];
                }
                if(sub2[i] != 0) {
                    v2 = v[i] + v[sub2[i]];
                    p2 = p[i] + p[sub2[i]];
                }
                if(sub1[i] != 0 && sub2[i] != 0) {
                    v3 = v1 + v2 - v[i];
                    p3 = p1 + p2 - p[i];
                }
                for (int j = 1; j < money + 1; j++) {
                    dp[i][j] = dp[i-1][j];//最大价值最少是这一件不放进去的大小
                    if(q[i] == 0) {
                        if(j >= v[i]) dp[i][j] = Math.max(dp[i][j], dp[i-1][j-v[i]] + p[i]);
                        if(v1 != -1 && j >= v1) dp[i][j] = Math.max(dp[i][j], dp[i-1][j-v1] + p1);
                        if(v2 != -1 && j >= v2) dp[i][j] = Math.max(dp[i][j], dp[i-1][j-v2] + p2);
                        if(v3 != -1 && j >= v3) dp[i][j] = Math.max(dp[i][j], dp[i-1][j-v3] + p3);
                    }
                }
            }
            System.out.println(dp[count][money] * dw);
    }
}

```

## 17、坐标移动 （中等）

```java
import java.io.*;
public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String input;
        while((input = br.readLine()) != null) {
            int x = 0;
            int y = 0;
            String[] strs = input.split(";");
            for(String str : strs) {
                int v = 0;
                if("".equals(str) || str.length() > 3) continue;
                for(int i = 1; i < str.length(); i++) {
                    int t = str.charAt(i) - '0';
                    if(t >= 0 && t <= 9) {
                        if(i == 1 && str.length() != 2) v += t * 10;
                        else v += t;
                    } else {
                        v = 0;
                        break;
                    }
                }
                char c = str.charAt(0);
                switch(c) {
                    case 'A':
                        x -= v;
                        break;
                    case 'D':
                        x += v;
                        break;
                    case 'W':
                        y += v;
                        break;
                    case 'S':
                        y -= v;
                        break;
                    default:
                        break;
                }
            }
            System.out.println(x + "," + y);
        }
    }
}
```

## 18、识别有效的IP地址和掩码并进行分类统计（较难） trans ？？

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String str = null;
        int a = 0, b = 0, c = 0, d = 0, e = 0, pir = 0, err = 0;
        while ((str = br.readLine()) != null && !str.isEmpty()) {
            int index = str.indexOf('~');
            long num1 = trans(str.substring(0, index));
            long num2 = trans(str.substring(index + 1));
            long t = num1 >> 24;
            if (t == 0 || t == 127) continue;
            if (t < 0) {
                err++;
                continue;
            }
            if (num2 <= 0 || num2 >= 0XFFFFFFFFL ||
                    (((num2 ^ 0XFFFFFFFFL) + 1) | num2) != num2) {
                err++;
                continue;
            }
            if (t >= 1 && t <= 126) {
                a++;
                if (t == 10)
                    pir++;
            } else if (t >= 128 && t <= 191) {
                b++;
                if (num1 >> 20 == 0xAC1)
                    pir++;
            } else if (t >= 192 && t <= 223) {
                c++;
                if (num1 >> 16 == 0xC0A8)
                    pir++;
            } else if (t >= 224 && t <= 239)
                d++;
            else if (t >= 240 && t <= 255)
                e++;
        }
        System.out.println(a + " " + b + " " + c + " " + d + " " + e + " " + err + " " +
                pir);
    }

    public static long trans(String str) {
        char[] cs = str.toCharArray();
        long res = 0, tmp = 0, flag = 0;
        for (char c : cs) {
            if (c == '.') {
                res = res << 8 | tmp;
                tmp = 0;
                flag++;
            } else if (c >= '0' && c <= '9') {
                tmp = tmp * 10 + c - '0';
                flag = 0;
            } else {
                return -1;
            }
            if (flag >= 2) return -1;

        }
        res = res << 8 | tmp;
        return res;
    }
}
```

## 19、简单错误记录（较难）

```java
// 这个不对，不知道哪儿写错了？？
//import java.io.BufferedReader;
//import java.io.IOException;
//import java.io.InputStreamReader;
//import java.util.LinkedHashMap;
//
//public class Main {
//    public static void main(String[] args) {
//        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
//        LinkedHashMap<String, Integer> data = new LinkedHashMap<>();
//        String line;
//
//        try {
//
//            while ((line = br.readLine() )!= null && !line.isEmpty())  {
//                int idx1 = line.indexOf(' ');
//                int idx2 = line.indexOf('\\');
//                // int idx1 = line.indexOf(" ");
//                // int idx2 = line.indexOf("\\");
//                String key = (idx1 - idx2) > 16 ? line.substring(idx1-16) : line.substring(idx2+1);
//                data.put(key, data.getOrDefault(key, 0) + 1);
//            }
//            int count = 0;
//            for (String key : data.keySet()) {
//                count++;
//                if (count > (data.size() - 8)) {
//                    System.out.println(key + " " + data.get(key));
//                }
//            }
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//    }
//}


import java.io.*;
import java.util.*;
public class Main{
    public static void main(String [] args) throws IOException{
        BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));
        String str;
        LinkedHashMap<String,Integer> data = new LinkedHashMap<String,Integer>();
        while((str = buffer.readLine())!=null && !str.isEmpty()){
            int idx1 = str.lastIndexOf(" ");
            int idx2 = str.lastIndexOf("\\");
            String key = (idx1-idx2)>16?str.substring(idx1-16):str.substring(idx2+1);
            data.put(key,data.getOrDefault(key,0)+1);
        }
        int count=0;
        for (String key:data.keySet()){
            count++;
            if(count>(data.size()-8)){
                System.out.println(key+" "+data.get(key));
            }
        }
    }
}
```

## 20、密码验证合格程序（中等）

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;


public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String input = null;
        StringBuilder sb = new StringBuilder();
        while(null != (input = reader.readLine()) && !input.isEmpty()) {
            boolean[] flag = new boolean[4];
            char[] chars = input.toCharArray();

            if (chars.length < 9) {
                sb.append("NG").append("\n");
                continue;
            }

            for (char c : chars) {
                if ('A' <= c && c <= 'Z') {
                    flag[0] = true;
                } else if ('a' <= c && c <= 'z') {
                    flag[1] = true;
                } else if ('0' <= c && c <= '9') {
                    flag[2] = true;
                } else {
                    flag[3] = true;
                }
            }
            int count = 0;
            for (int i=0; i<4; i++) {
                if (flag[i]) {
                    count++;
                }
            }

            boolean sign = true;
            for (int i=0; i<chars.length-5; i++) {
                for (int j=i+3; j<chars.length-2; j++) {
                    if (chars[i] == chars[j] && chars[i + 1] == chars[j + 1] && chars[i + 2] == chars[j + 2]) {
                        sign = false;
                        break;
                    }
                }
            }
            if (count >= 3 && sign) {
                sb.append("OK").append("\n");
            } else {
                sb.append("NG").append("\n");
            }
        }
        System.out.println(sb.toString());
    }
}

```

## 21、简单密码（简单）

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;


public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        // 一次读取
        String str = reader.readLine();
        StringBuffer sb = new StringBuffer();
        for (int i=0; i<str.length(); i++) {
            char c = str.charAt(i);
            if (c >= 'A' && c <'Z') {
                // 转换为小写字母 差值32='b' - 'A'
                c = (char)(c + 'b' - 'A');
            } else if (c == 'Z') {
                c = 'a';
            } else if (c >= 'a' && c <= 'c') {
                c = '2';
            } else if (c >= 'd' && c <= 'f') {
                c = '3';
            } else if (c >= 'g' && c <= 'i') {
                c = '4';
            } else if (c >= 'j' && c <= 'l') {
                c = '5';
            } else if (c >= 'm' && c <= 'o') {
                c = '6';
            } else if (c >= 'p' && c <= 's') {
                c = '7';
            } else if (c >= 't' && c <= 'v') {
                c = '8';
            } else if (c >= 'w' && c <= 'z') {
                c = '9';
            }
            sb.append(c);

        }
        System.out.println(sb.toString().trim());
    }
}

```

## 22、汽水瓶（简单）

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;


public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String str = null;
        while ((str = reader.readLine()) != null) {
            int g = Integer.parseInt(str);
            if (g == 0) {
                return;
            }
            int count = 0;
            // Condition 'g != 0' is always 'true' 
            // while (g != 0) {
            //     int f = g / 3;
            //     count += f;
            //      g = g % 3 + f;
            //     if (g < 3) {
            //         break;
            //     }
            // }
            do {
                int f = g / 3;
                count += f;
                g = g % 3 + f;
            } while (g >= 3);
            if (g == 2) {
                count += 1;
            }
            System.out.println(count);
        }
    }
}

```

## 23、删除字符串中出现次数最少的字符（简单）

自己：
```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;


public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String str = null;
        while ((str = reader.readLine()) != null) {
            LinkedHashMap<Character, Integer> map = new LinkedHashMap<>();
            for (int i =0; i<str.length(); i++) {
                char c = str.charAt(i);
                map.put(c, map.getOrDefault(c, 0) + 1);
            }
            Map.Entry<Character, Integer> minEntry = null;
            for (Map.Entry<Character, Integer> entry: map.entrySet()) {
                if (minEntry == null || entry.getValue() < minEntry.getValue()) {
                    minEntry = entry;
                }
            }
            // System.out.println("map: " + map.toString().trim());

            StringBuilder sb = new StringBuilder();
            // for (Map.Entry<Character, Integer> entry: map.entrySet()) {
            //     // if (minEntry != null && entry.getValue() != minEntry.getValue())
            //     if (minEntry != null && !Objects.equals(entry.getValue(), minEntry.getValue())) {
            //         sb.append(entry.getKey());
            //     }
            // }
            for (char c: str.toCharArray()) {
                if (minEntry != null && c != minEntry.getKey() && !Objects.equals(map.get(c), minEntry.getValue())) {
                    sb.append(c);
                }
            }
            System.out.println(sb.toString().trim());

        }
    }
}
```

排第一的：
```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Arrays;


public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String input;
        while((input = reader.readLine())!= null) {
            char[] ch = input.toCharArray();
            int[] count = new int[ch.length];
            int[] newCount = new int[ch.length];
            for (int i=0; i<ch.length-1; i++) {
                for (int j=i+1; j<ch.length; j++) {
                    if (ch[i] == ch[j]) {
                        count[i]++;
                        count[j]++;
                    }
                }
            }
            // for (int i=0; i<newCount.length; i++) {
            //     newCount[i] = count[i];
            // }
            System.arraycopy(count, 0, newCount, 0, newCount.length);
            Arrays.sort(count);
            for (int i=0; i<ch.length; i++) {
                if (newCount[i] > count[0]) {
                    System.out.print(ch[i]);
                }
            }
            System.out.println();
        }
    }
}

```

第二的：while(s!=null && s.length()!=0) { 操作; s = br.readLine(); }
```java
import java.io.*;
import java.util.*;

public class Main{
    
    public static void main(String[] args)throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String s = br.readLine();
        while(s!=null && s.length()!=0){
            System.out.println(updateString(s));
            s = br.readLine();
        }
    }
    public static String updateString(String s){
        char[] charArray = s.toCharArray();
        int[] count = new int[26];
        for(char c: charArray){
            count[c-'a']++;
            
        }
        int min = 20;
        for(int i: count){
            if(i >0 && i<min)min=i;
        }
        
        StringBuilder sb = new StringBuilder();
        for(char c : charArray){
            if(count[c-'a']!=min)sb.append(c);
        }
        return sb.toString();
        
        
    }
}
```

## 24、合唱队（中等）【再刷】

```java
import java.io.*;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String str = null;
        while ((str = br.readLine()) != null) {
            if (str.equals("")) continue;
            int n = Integer.parseInt(str);
            int[] heights = new int[n];
            String[] str_heights = br.readLine().split(" ");
            // 当仅有一个人时，其自己组成一个合唱队，出列0人
            if (n <= 1) System.out.println(0);
            else {
                for (int i = 0; i < n; i++) heights[i] = Integer.parseInt(str_heights[i]);
                // 记录从左向右的最长递增子序列和从右向左的最长递增子序列
                int[] seq = new int[n], rev_seq = new int[n];
                int[] k = new int[n];  // 用于记录以i为终点的从左向右和从右向走的子序列元素个数
                seq[0] = heights[0];  // 初始化从左向右子序列首元素为第一个元素
                int index = 1; // 记录当前子序列的长度
                for (int i = 1; i < n; i++) {
                    if (heights[i] > seq[index-1]) {  // 当当前元素大于递增序列最后一个元素时
                        k[i] = index;  // 其左边元素个数
                        seq[index++] = heights[i];  // 更新递增序列
                    } else {  // 当当前元素位于目前维护递增序列之间时
                        // 使用二分搜索找到其所属位置
                        int l = 0, r = index - 1;
                        while (l < r) {
                            int mid = l + (r - l) / 2;
                            if (seq[mid] < heights[i]) l = mid + 1;
                            else r = mid;
                        }
                        seq[l] = heights[i];  // 将所属位置值进行替换
                        k[i] = l;  // 其左边元素个数
                    }
                }

                // 随后，再从右向左进行上述操作
                rev_seq[0] = heights[n-1];
                index = 1;
                for (int i = n - 2; i >= 0; i--) {
                    if (heights[i] > rev_seq[index-1]) {
                        k[i] += index;
                        rev_seq[index++] = heights[i];
                    } else {
                        int l = 0, r = index - 1;
                        while (l < r) {
                            int mid = l + (r - l) / 2;
                            if (rev_seq[mid] < heights[i]) l = mid + 1;
                            else r = mid;
                        }
                        rev_seq[l] = heights[i];
                        k[i] += l;
                    }
                }

                int max = 1;
                for (int num: k)
                    if (max < num) max = num;
                // max+1为最大的k
                System.out.println(n - max - 1);
            }
        }
    }
}

```

## 25、数据分类处理（困难）【题没怎么读懂，再刷】

```java
/*
import java.util.*;
public class Main{
    public static void main(String[] a){
        Scanner s = new Scanner(System.in);
        while(s.hasNext()){
            String s1 = s.nextLine();
            String s2 = s.nextLine();
            String[] ss1 = s1.split(" ");
            String[] ss2 = s2.split(" ");
            int[] is1 = new int[Integer.parseInt(ss1[0])];
            int[] is3 = new int[Integer.parseInt(ss2[0])];
            Set<Integer> set = new LinkedHashSet<>();
            
            for(int i=0;i<is1.length;i++){
                is1[i] = Integer.parseInt(ss1[i+1]);
            }
            for(int i=0;i<is3.length;i++){
                is3[i] = Integer.parseInt(ss2[i+1]);
            }
            for(int i=0;i<is3.length;i++){
                set.add(is3[i]);
            }
            int[] is2 = new int[set.size()];
            int k = 0;
            for(Integer key : set){
                is2[k] = key;
                k++;
            }
            Map<Integer,String> map = new LinkedHashMap<>();
            Arrays.sort(is2);
            int num = 0;
            for(int i=0;i<is2.length;i++){
                int n = 0;
                map.put(is2[i],"");
                for(int j=0;j<is1.length;j++){
                    if((""+is1[j]).indexOf(""+is2[i]) != -1){
                        map.put(is2[i],map.get(is2[i]) + " " + j + " " + is1[j]);
                        n++;
                        num+=2;
                    }
                }
                map.put(is2[i], n + map.get(is2[i]));
                if(n!=0){
                    num+=2;
                }
            }
            System.out.print(num);
            for(Integer i : map.keySet()){
                if(map.get(i).length() != 1){
                    System.out.print( " "+i +" "+ map.get(i));
                }
            }
        }
    }
}
*/

import java.io.*;
import java.util.*;

public class Main {//数据分类处理
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String str = null;
        while ((str = br.readLine()) != null) {
            if (str.equals("")) continue;
            String[] I = str.split(" ");
            String[] temp = br.readLine().split(" ");
            long[] R = new long[Integer.parseInt(temp[0])];
            for (int i = 0; i < R.length; i++) R[i] = Long.parseLong(temp[i+1]);
            Arrays.sort(R);
            StringBuilder res = new StringBuilder();
            int count = 0;
            for (int i = 0; i < R.length; i++) {
                if (i > 0 && R[i] == R[i-1]) continue;
                String pattern = R[i] + "";
                int num = 0;
                StringBuilder index = new StringBuilder();
                for (int j = 1; j < I.length; j++) {
                    if (I[j].indexOf(pattern) != -1) {
                        num++;
                        index.append(" ").append(j-1).append(" ").append(I[j]);
                    }
                }
                if (num > 0){
                    res.append(" ").append(R[i]).append(" ").append(num).append(index);
                    count+=num*2+2;
                }
            }
            System.out.println(count + res.toString());
        }
    }
}
```

## 26、字符串排序（中等）String.valueOf(数组)

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class Main{
    public static void main(String[] args) throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String s;
        while((s = br.readLine()) != null){
            char[] ch = s.toCharArray();
            char[] chars = new char[ch.length];
            int flag = 65, j=0;
            while(flag<=90){
                for (char c : ch) {
                    if ((c >= 65 && c <= 90) || (c >= 97 && c <= 122)) {
                        if (c == flag || c == flag + 32) {
                            chars[j] = c;
                            j++;
                        }
                    }
                }
                flag++;
            }

            j=0;
            for(int i=0; i<ch.length; i++){
                if((ch[i]>=65&&ch[i]<=90) || (ch[i]>=97&&ch[i]<=122)){
                    ch[i] = chars[j];
                    j++;
                }
            }
            System.out.println(String.valueOf(ch));
        }
    }
}

```

## 27、查找兄弟单词（中等）Collections.sort(数组ArrayList) 数组.get(索引)

```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader bf=new BufferedReader(new InputStreamReader(System.in));
        String s=null;
        while((s=bf.readLine())!=null){
            // 将输入的字符串分割成字符串数组
            String[] words=s.split(" ");
            // 待查找单词
            String str=words[words.length-2];
            // 兄弟单词表里的第k个兄弟单词
            int k=Integer.parseInt(words[words.length-1]);
            // 存放兄弟单词表
            ArrayList<String> broWords=new ArrayList<>();
            // 遍历输入的单词
            for (int i = 1; i < words.length-2; i++) {
                // 不相等且长度相同
                if((!words[i].equals(str)) && words[i].length()==str.length()) {
                    char[] chStr=str.toCharArray();
                    char[] word=words[i].toCharArray();
                    int temp=0;
                    for (int j = 0; j < chStr.length; j++) {
                        for (int j2 = 0; j2 < word.length; j2++) {
                            if (word[j]==chStr[j2]) {
                                // 使用j2作为索引是为了确保在内层循环中能够准确地标记chStr中已经被匹配到的字符，从而避免重复匹配和错误的结果
                                chStr[j2]='0';
                                temp++;
                                break;
                            }
                        }
                    }
                    if (temp==chStr.length) {
                        broWords.add(words[i]);
                    }
                }
            }
            System.out.println(broWords.size());
            if(k>0 && k<=broWords.size()) {
                Collections.sort(broWords);
                System.out.println(broWords.get(k-1));
            }
        }
    }
}

```

## 28、素数伴侣（困难）[再刷]

prime

```java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String line = null;
        while((line = br.readLine()) != null) {
            int count = Integer.parseInt(line);
            String[] elements = br.readLine().split(" ");
            int[] nums = new int[count];
            int oddCount = 0;
            int index = 0;
            for(String ele : elements) {
                nums[index] = Integer.parseInt(ele);
                if(nums[index] % 2 == 1) {
                    oddCount++;    //记录奇数个数
                }
                index++;
            }
            
            int[] oddNums = new int[oddCount];
            int[] evenNums = new int[count - oddCount];
            int oddIndex = 0;
            int evenIndex = 0;
            //奇偶分离
            for(int num : nums) {
                if(num % 2 == 0) {
                    evenNums[evenIndex++] = num;
                } else {
                    oddNums[oddIndex++] = num;
                }
            }
            
            int pairCount = 0;
            int[] evenPair = new int[evenIndex];
            for(int i = 0; i < oddIndex; i++) {
                boolean[] used = new boolean[evenIndex];
                if(findPair(i, oddNums, evenNums, evenPair, used)){
                    pairCount++;
                }
            }
            System.out.println(pairCount);
        }
    }
    
    /**
    偶数+奇数才可能是素数
    */
    private static boolean findPair(int oddIndex, int[] oddNums, int[] evenNums, int[] evenPair, boolean[] used) {
        for(int i = 0;i < evenNums.length; i++) {
            if(!used[i] && isP(oddNums[oddIndex] + evenNums[i])) {
                used[i] = true;
                if(evenPair[i] == 0 || findPair(evenPair[i] - 1,oddNums,evenNums,evenPair,used)) {
                    evenPair[i] = oddIndex + 1;
                    return true;
                }
            }
        }
        return false;
    }
    
    //见过比较经典的思路
    private static boolean isP(int num) {
        if(num <= 3) {
            return num > 1;    // 2,3都是素数
        }
        //6*n+2;6*n+3;6*n+4;6*n等都不是素数;可过滤掉2/3的判断
        if(num % 6 != 1 && num % 6 !=5) {
            return false;
        }
        
        double sqrt = Math.sqrt(num);
        for (int i = 5; i < sqrt; i += 6) {
            //只变量2类数据num % 6 == 1 num % 6 == 5
            if (num % i == 0 || num % (i + 2) == 0) {
                return false;
            }
        }
        return true;
    }
}
```

## 29、字符串加解密（中等）Encrypt

```java
 
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.Scanner;

public class Main{
	public static void main(String []args) throws Exception{
   BufferedReader br=new BufferedReader(new InputStreamReader(System.in));
	 String str="";
	 while((str=br.readLine())!=null) {
		 String word=br.readLine();
		 System.out.println(jiami(str));
		 System.out.println(jiemi(word));
 	}
}
	public static String jiami(String str) {
		char ch[]=str.toCharArray();
		StringBuilder sb=new StringBuilder();
		
		for(int i=0;i<ch.length;i++) {
			if(ch[i]>='a'&&ch[i]<='z') {
				if(ch[i]=='z')
					sb.append('A');
				else 
					sb.append((char)(ch[i]-32+1));
				
			}
			else if(ch[i]>='A'&&ch[i]<='Z') {
				if(ch[i]=='Z')
					sb.append('a');
				else 
					sb.append((char)(ch[i]+32+1));
		 	}
			else if(ch[i]>='0'&&ch[i]<='9') {
				if(ch[i]=='9')
					sb.append('0');
				else 
					sb.append(ch[i]-'0'+1);
				
			}
		
 		}
		
		return sb.toString();
	}
	
	public static String jiemi(String str) {
		char ch[]=str.toCharArray();
		StringBuilder sb=new StringBuilder();
		
		for(int i=0;i<ch.length;i++) {
			if(ch[i]>='a'&&ch[i]<='z') {
				if(ch[i]=='a')
					sb.append('Z');
				else 
					sb.append((char)(ch[i]-32-1));
				
			}
			else if(ch[i]>='A'&&ch[i]<='Z') {
				if(ch[i]=='A')
					sb.append('z');
				else 
					sb.append((char)(ch[i]+32-1));
		 	}
			else if(ch[i]>='0'&&ch[i]<='9') {
				if(ch[i]=='0')
					sb.append('9');
				else 
					sb.append(ch[i]-'0'-1);
				
			}
		
 		}
		
		return sb.toString();
	}
	
	
	
}
```

```java
import java.util.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.TreeSet;
//给定一个字符串数组。按照字典顺序进行从小到大的排序。
 
 
public class Main {
    public static void main(String[]args)throws IOException{
        BufferedReader bt = new BufferedReader(new InputStreamReader(System.in));
        String str ="";
        while((str=bt.readLine())!=null) {
            String res = Encrypt(str);
            System.out.println(res);
            str=bt.readLine();
            String res2 = unEncrypt(str);
            System.out.println(res2);
        }
    }
    public static String Encrypt(String str) {
        char[] ch=str.toCharArray();
        char[] newch = new char[ch.length];
        for(int i=0; i<ch.length;i++) {
            char c = ch[i];
            if(c>='a'&& c<'z')
                newch[i]=(char)(c-31);
            if(c=='z')
                newch[i]='A';
            if(c>='A'&&c<'Z')
                newch[i]=(char)(c+33);//转换成小写
            if(c=='Z')
                newch[i]='a';
            if(c>='0'&&c<'9')
                newch[i]=(char)(c+1);
            if(c=='9')
                newch[i]='0';
             
    }
        return String.valueOf(newch);
     
}
    public static String unEncrypt(String str1) {
        char[] ch=str1.toCharArray();
        char[] newch = new char[ch.length];
        for(int i=0; i<ch.length;i++) {
            char c = ch[i];
            if(c>'a'&& c<='z')
                newch[i]=(char)(c-33);
            if(c=='a')
                newch[i]='Z';
            if(c>'A'&&c<='Z')
                newch[i]=(char)(c+31);//
            if(c=='A')
                newch[i]='z';
            if(c>'0'&&c<='9')
                newch[i]=(char)(c-1);
            if(c=='0')
                newch[i]='9';
             
    }
        return String.valueOf(newch);
     
    }
}
```

## 30、字符串合并处理（较难）InputStream in = System.in; int count = in.available();  Arrays.copyOfRange() [再刷]

```java
import java.util.*;
import java.io.*;

public class Main{
    public static void main(String[] args) throws IOException{
        BufferedReader bf = new BufferedReader(new InputStreamReader(System.in));
        String s = null;
        while((s = bf.readLine())!=null){
            String[] str = s.split(" ");
            s = str[0] + str[1];
            char[] array = sort(s);
            System.out.println(transform(array));    
        }
    }
    
    public static char[] sort(String s){
        char[] array = s.toCharArray();
        int i,j;
        for(i=2;i<array.length;i+=2){
            if(array[i] < array[i-2]){
                char tmp = array[i];
                for(j=i;j>0 && array[j-2] > tmp; j-=2){
                    array[j] = array[j-2];
                }
                array[j] = tmp;
            }
        }
        for(i=3;i<array.length;i+=2){
            if(array[i] < array[i-2]){
                char tmp = array[i];
                for(j=i;j>1 && array[j-2]>tmp;j-=2){
                    array[j] = array[j-2];
                }
                array[j] = tmp;
            }
        }
        return array;
    }

    public static String transform(char[] array){
        for(int i=0;i<array.length;i++){
            int num = -1;
            if(array[i] >= 'A' && array[i] <= 'F'){
                num = array[i]-'A'+10;
            }else if(array[i] >= 'a' && array[i] <= 'f'){
                num = array[i]-'a'+10;
            }else if(array[i] >= '0' && array[i] <= '9'){
                num = array[i]-'0';
            }

            if(num != -1){ // 需要转换
                num = (num&1)*8 + (num&2)*2 + (num&4)/2 + (num&8)/8;
                if(num<10){
                    array[i] = (char)(num+'0');
                }else if(num<16){
                    array[i] = (char)(num-10+'A');
                }
            }
        }
        return new String(array);
    }
}
```

```java
import java.util.*;
import java.io.*;
public class Main{
    public static void main(String[] args) throws IOException{
        InputStream in = System.in;
        int count = in.available();
        char c;
        char[] str1,str2;
        int len1,len2;
        while(count>0){
            str1 = new char[count];
            str2=new char[count];
            len1=0;
            len2=0;
            while(count>0){
                count--;
                c = (char)in.read();
                if(c=='\n'){
                    break;
                }
                if(c!=' '){
                    if(len1==len2){
                        str1[len1] = c;
                        len1++;
                    }else{
                        str2[len2] = c;
                        len2++;
                    }
                }
            }
            // 裁剪出数组的有效部分，并排序
            char[] c1 = Arrays.copyOfRange(str1,0,len1),c2=Arrays.copyOfRange(str2,0,len2);
            Arrays.sort(c1);
            Arrays.sort(c2);
            // new新数组，把两个数组错位合并到一起
            char[] result = new char[len1+len2];
            for(int i=0;i<result.length;i++){
                if(i%2==0){
                    result[i] = change(c1[i/2]);
                }else{
                    result[i] = change(c2[i/2]);
                }
            }
            System.out.println(result);
        }
    }
    // 字符转为要求的格式
    public static char change(char c){
        int n = 0,sum=0;
        // 对十六进制内的字符做转十进制转换
        if(c>='0'&&c<='9'){
            n = c - '0';
        }else if(c>='a'&&c<='f'){
            n = c - 'a' + 10;
        }else if(c>='A'&&c<='F'){
            n = c - 'A'+ 10;
        }else{
            return c;
        }
        // 倒置
        for(int i=0;i<4;i++){
            sum = n%2 + sum * 2;
            n /= 2;
        }
        // 整数转16进制
        if(sum>9){
            return (char)('A'+(sum-10));
        }else{
            return (char)('0'+sum);
        }
        
    }
}
```

## 31、单词倒排（简单）sb.append(array, 0, mark + 1); System.arraycopy

```java
import java.io.*;
public class Main{
    public static void main(String[] args) throws Exception {
        InputStream in = System.in;
        int available = in.available();
        char[] arr = new char[available];
        int off_word = 0;
        int off_end = arr.length;
        char c;
        for(int i = 0; i < available; i++) {
            c = (char) in.read();
            if((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) {
                arr[off_word++] = c;
            } else if(off_word > 0) {
                System.arraycopy(arr, 0, arr, off_end - off_word, off_word);
                off_end -= off_word + 1;
                off_word = 0;
                arr[off_end] = ' ';
            }
        }
        System.out.println(String.valueOf(arr, off_end + 1, arr.length - off_end - 1));
    }
}
```

```java
import java.io.*;
 
 
public class Main {
    public static void main(String[] args) throws Exception {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String line;
        while ((line = br.readLine()) != null && line.length() > 0) {
            char[] array = line.trim().toCharArray();
            StringBuilder sb = new StringBuilder();
            boolean flag = false;
            int mark = -1;
            for (int i = array.length - 1; i >= 0; i--) {
                if ((array[i] >= 'A' && array[i] <= 'Z') || (array[i] >= 'a' && array[i] <= 'z')) {
                    if (mark == -1)
                        mark = i;
                    flag = true;
                } else if (flag) {
                    sb.append(array, i + 1, mark - i).append(' ');
                    mark = -1;
                    flag = false;
                }
            }
            if (flag) {
                sb.append(array, 0, mark + 1);
                System.out.println(sb.toString());
            } else {
                System.out.println(sb.substring(0, sb.length() - 1));
            }
        }
    }
 
}
```


自己：没过
```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader bf=new BufferedReader(new InputStreamReader(System.in));
        String s=null;
        while((s=bf.readLine())!=null){
            char[] chars=s.toCharArray();
            StringBuilder sb = new StringBuilder();
            ArrayList<String> list = new ArrayList<>();
            for (char c : chars) {
                if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) {
                    sb.append(c);
                }
                // 最后一个字符的时候怎么处理？
                else {
                    list.add(sb.toString());
                    sb = new StringBuilder();
                }
            }
            Collections.reverse(list);
            for (String str : list) {
                System.out.print(str + " ");
            }
        }
    }
}
```