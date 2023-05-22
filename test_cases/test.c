enum color {RED, GREEN, BLUE};

int main() {
    enum color c = RED;
    enum color d = GREEN;
    if (c != d) {
        c = BLUE;
    }endif

    return 0;
}
