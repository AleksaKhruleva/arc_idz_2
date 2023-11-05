#include <iostream>
#include <cmath>
#include <iomanip>

using namespace std;

typedef double(*target_func_pointer)(void *, double);

struct target_func_struct {
    double A;
    double B;
} target_func_data;

void configure_func(target_func_struct *_data, double a, double b) {
    _data->A = a;
    _data->B = b;
}

double the_func(void *_data, double x) {
    auto *data = (target_func_struct *) _data;
    return (data->A + data->B / (x * x));
}

double simpsonIntegral(target_func_pointer the_func, void *func_data, double x1, double x2, int n) {
    double d = (x2 - x1) / n;
    double si = 0;
    for (int i = 0; i < n; i++) {
        double p1 = x1 + i * d;
        double p2 = x1 + i * d + d;
        double f1 = the_func(func_data, p1);
        double f2 = the_func(func_data, (p1 + p2) / 2.0);
        double f3 = the_func(func_data, p2);
        si += (p2 - p1) / 6.0 * (f1 + 4.0 * f2 + f3);
    }
    return si;
}

int main() {
    double a = 1, b = 1, eps = 0.0001, x1 = 2, x2 = 3;
    double t2, t1;
    int n;

    cout << "Input  A, function argument (double): ";
    cin >> a;
    cout << "Input  B, function argument (double): ";
    cin >> b;
    configure_func(&target_func_data, a, b);
    cout << "Input X1, left  boundary of integration (double): ";
    cin >> x1;
    cout << "Input X2, right boundary of integration (double): ";
    cin >> x2;

    n = 1; //начальное число шагов
    t2 = simpsonIntegral(the_func, &target_func_data, x1, x2, n); //первое приближение для интеграла
    do {
        t1 = t2;     // второе приближение
        n = 2 * n;  // увеличение числа шагов в два раза,
        //т.е. уменьшение значения шага в два раза
        t2 = simpsonIntegral(the_func, &target_func_data, x1, x2, n);
    } while (fabs(t2 - t1) > eps);  //сравнение приближений с заданной точностью

    cout << "Result: " << std::setprecision(17) << t2 << endl;
}

