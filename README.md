# Project Title

Work time manager 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine.


### Installing

Change to your user's home directory
so you will clone the project there later (you can choose any other loacation) 

```
cd ~
```

Clone the project:

```
git clone https://github.com/chn555/timestamp.git
```


## Running the script

Change to the project's directory:

```
cd timestamp
```

To start the timer:

```
bash timerstart.sh
```
To stop the timer and see for how long have you worked:

```
bash timerstop.sh
```


* If you want to see the data from SQLite after you run the script:

```
sqlite3 ./timestamp.db "SELECT * FROM stamps"
```


## Built With

* [Atom](https://atom.io/) - The text editor used

## Authors

* **Chen T.** - [Chn555](https://github.com/chn555)

* **Tom H.** - [BigRush](https://github.com/bigrush)

## License

This project is licensed under the GPLv3 License - see the [LICENSE](https://github.com/chn555/timestamp/blob/master/LICENSE) file for details

## Acknowledgments

Thanks to [silent-mobius](https://github.com/silent-mobius) for giving the idea and mentoring us through the process.
