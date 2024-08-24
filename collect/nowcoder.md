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


