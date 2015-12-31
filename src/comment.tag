<comment>
    <commentform name="form" />
    <commentlist name="list" />
</comment>

<commentform>
    <h3>{ title }</h3>
    <p>{ message }</p>
    <form onsubmit="{ add }">
        <div>
            <label for="author_name">Author Name</label>
            <input id="author_name" name="author_name" type="text" />
        </div>
        <div>
            <label for="author_email">Author Email</label>
            <input id="author_email" name="author_email" type="text" />
        </div>
        <div>
            <label for="content">Comment</label>
            <textarea id="content" name="content" />
        </div>
        <button>Submit</button>
    </form>
    <hr />
    
    var self = this
    self.title = self.parent.opts.form.title
    self.message = self.parent.opts.form.default_message
    self.post_id = self.parent.opts.post_id
    self.endpoint = self.parent.opts.endpoint
    
    add(e) {
        request
            .post(self.endpoint)
            .type('form')
            .withCredentials()
            .send({
                post: self.post_id,
                author_name: self.author_name.value,
                author_email: self.author_email.value,
                content: self.content.value
            })
            .end(function(err, res){
                console.log('Successfully post new comment to post ' + self.post_id)
                self.parent.tags.list.add(res.body)
                self.author_name.value = self.author_email.value = self.content.value = ''
                self.message = 'Thanks!'
                self.update()
            })
    }
</commentform>

<commentlist>
    <h3>{ title }</h3>
    <div each={ items }>
        <h4>{ author_name }</h4>
        <commentbody content="{ content.rendered }" />
        <hr />
    </div>
    
    var self = this
    self.title = self.parent.opts.list.title
    self.post_id = self.parent.opts.post_id
    self.endpoint = self.parent.opts.endpoint
    
    request
        .get(self.endpoint)
        .withCredentials()
        .query({ post: self.post_id })
        .end(function(err, res){
            console.log('Successfully retreive comments from post ' + self.post_id)
            self.items = res.body
            self.update()
        })
    
    add(item) {
        self.items.unshift(item)
        self.update()
    }

</commentlist>

<commentbody>
    this.root.innerHTML = opts.content
</commentbody>