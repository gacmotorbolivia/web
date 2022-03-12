from setuptools import setup, find_packages

REQUIREMENTS = [
    
]


setup(
    name="gac",
    author="bjvSoft",
    author_email="brandon.valle@bjvsoft.net",
    version="1.0",
    package_dir={"": "src"},
    packages=find_packages("src"),
)
