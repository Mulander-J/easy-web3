const checkForKey = () => {
    return new Promise((resolve, reject) => {
        chrome.storage.local.get(['openai-key'], (result) => {
            resolve(result['openai-key']);
        });
    });
};

const encode = (input) => {
    return btoa(input);
};

const saveKey = () => {
    const input = document.getElementById('key_input');

    if (input) {
        const { value } = input;

        // Encode String
        const encodedValue = encode(value);

        // Save to google storage
        chrome.storage.local.set({ 'openai-key': encodedValue }, () => { triggerKeyUI(true) });
    }    
}

const changeKey = () => { triggerKeyUI(false) }

const triggerKeyUI = (state)=>{
    document.getElementById('key_needed').style.display = state ? 'none' : 'block';
    document.getElementById('key_entered').style.display = state ? 'block' : 'none';    
}

document
.getElementById('save_key_button')
.addEventListener('click', saveKey);

document
.getElementById('change_key_button')
.addEventListener('click', changeKey);


checkForKey().then((response) => { response && triggerKeyUI(true) });