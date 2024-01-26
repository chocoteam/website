+++
weight = 20
+++

{{% section %}}

# Getting Started

--- 

- JRE 11+ installed ([Oracle](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://jdk.java.net/21/))
- Easier with:
	- an IDE: [IntelliJ IDEA](https://www.jetbrains.com/idea/), [Eclipse IDE](https://www.eclipse.org/downloads/), [Apache NetBeans](https://netbeans.apache.org/) or [VSCode](https://code.visualstudio.com/)
	- a build automation tool: [Apache Maven 3+](https://maven.apache.org/download.cgi) or [Gradle 6+](https://gradle.org/releases/)  

--- 

{{< slide background-iframe="https://choco-solver.org/docs/getting-started/" >}}

--- 

## A first example

```java{}
int n = 8;
Model model = new Model(n + "-queens problem");
IntVar[] vs = model.intVarArray("Q", n, 1, n);
model.allDifferent(vs).post();
for(int i  = 0; i < n-1; i++){
    for(int j = i + 1; j < n; j++){
        model.arithm(vs[i], "!=", vs[j], "-", j - i).post();
        model.arithm(vs[i], "!=", vs[j], "+", j - i).post();
    }
}
Solution solution = model.getSolver().findSolution();
if(solution != null){
    System.out.println(solution.toString());
}
```


{{% /section %}}