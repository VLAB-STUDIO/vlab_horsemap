window.addEventListener('message', function(event) {
    if (event.data.type === 'showImage') {
        document.getElementById('image-container').style.display = 'block';
        document.getElementById('horse-image').src = event.data.image;
    } else if (event.data.type === 'hideImage') {
        document.getElementById('image-container').style.display = 'none';
    }
});