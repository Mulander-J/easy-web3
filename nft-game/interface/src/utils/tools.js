export const shortenString = (str) => {
    return !str ? '' : str.length <= 11 ? str : str.substring(0, 6) + '...' + str.substring(str.length - 4)
}